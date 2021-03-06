import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map/Add/addScreen.dart';
import 'package:map/DataController.dart';
import 'package:map/home/MapPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../Details/DetailsScreen.dart';
import '../Entities/Site.dart';
import '../home_page_icons_icons.dart';
import 'SearchBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.siteList}) : super(key: key);

  final List<Site> siteList;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapType _mapType = MapType.normal;
  double _layersIconRightFlow = 0;
  double _layersIconBottomFlow = 90;
  LatLng? _selectedLocation;
  final int _speed = 250;
  double _addPadding = -100;
  double _bottomPadding = 50;
  double _buttonPadding = 0;
  double _zoomState = 11.5;
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  Marker? _destination;
  late Uint8List markerIcon;
  late Uint8List lastPosMarkerIcon;
  late Uint8List mySiteMarkerIcon;
  //late Marker marker;
  StreamSubscription<LocationData>? _locationListener = null;
  DataController dataController = new DataController();

  double calculateDistance(LatLng a, LatLng b) {
    var p = 0.017453292519943295;
    var r = 0.5 -
        cos((b.latitude - a.latitude) * p) / 2 +
        cos(a.latitude * p) *
            cos(b.latitude * p) *
            (1 - cos((b.longitude - a.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(r));
  }

  Future nearSites() async {
    List<Marker> sites = [];
    LocationData myLocation = await currentLocation.getLocation();

    return dataController.getData('sites').then((value) {
      if (myLocation.latitude == null && myLocation.longitude == null) return;
      LatLng position = LatLng(myLocation.latitude!, myLocation.longitude!);

      value.docs.forEach((siteQuery) {
        Site site = Site.queryToSite(siteQuery);
        double distance = calculateDistance(position, site.coordinates!);
        print("My distance is " + distance.toString());
        if (distance <= 10) {
          site
              .siteToMarker(BitmapDescriptor.fromBytes(mySiteMarkerIcon))
              .then((value) {
            sites.add(value!);
            print("my distance is " + sites.length.toString());
            setState(() {
              _markers.addAll(sites);
            });
          });
          print("my distance is valid");
        }
      });

      print("my last distance is " + sites.length.toString());
    });
  }

  bool _activatedSearch = MapPreferences.getLocationState();
  Icon _findMe = Icon(
    Icons.my_location,
    color: Colors.white,
  );

  List<Marker> addSearchedSites() {
    List<Marker> sites = [];

    widget.siteList.forEach((element) {
      sites.add(new Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: MarkerId(element.id!),
          position: element.coordinates!,
          onTap: () {
            MapPreferences.setLocation(element.coordinates!);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                        site: element,
                      )),
            );
          }));
    });

    return sites;
  }

  void getLocation() async {
    //var location = await currentLocation.getLocation();
    lastPosMarkerIcon =
        await getBytesFromAsset("assets/images/lastPosMarker.png", 100);
    markerIcon = await getBytesFromAsset("assets/images/marker.png", 100);
    mySiteMarkerIcon =
        await getBytesFromAsset("assets/images/my-site-marker.png", 80);
    setState(() {
      _locationListener =
          currentLocation.onLocationChanged.listen((LocationData loc) {
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
          zoom: _zoomState,
        )));

        _markers = {};
        _markers.add(Marker(
            icon: BitmapDescriptor.fromBytes(markerIcon),
            markerId: const MarkerId("Me"),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
        if (widget.siteList.isNotEmpty)
          _markers.addAll(addSearchedSites());
        else
          nearSites();

        _locationListener?.cancel();
      });
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    setState(() {
      getLocation();
    });
  }

  void _onZoomChanged(CameraPosition position) {
    setState(() {
      _zoomState = position.zoom;
    });
  }

  void _changeTapScreen(LatLng x) {
    setState(() {
      _addPadding = -100;
      _bottomPadding = -_bottomPadding;
      _layersIconRightFlow = (_layersIconRightFlow - 100).abs();
      _layersIconBottomFlow = 90;
      if (_buttonPadding > 0) _buttonPadding = 0;
    });
  }

  void _switchMyLocation() {
    print("Activated: " + _activatedSearch.toString());
    setState(() {
      _activatedSearch = !_activatedSearch;
      if (_activatedSearch) {
        _findMe = new Icon(
          Icons.my_location,
          color: Colors.white,
        );
      } else {
        _findMe = Icon(
          Icons.location_searching,
          color: Colors.white,
        );
        Marker marker = _markers.first;
        marker = Marker(
            icon: BitmapDescriptor.fromBytes(lastPosMarkerIcon),
            markerId: const MarkerId("LastMe"),
            position: marker.position);
        _markers = {marker};
        _locationListener?.cancel();
      }
    });
    print("set location to " + _activatedSearch.toString());
    MapPreferences.setLocationState(_activatedSearch);
  }

  void _addMe(LatLng ll) {
    print("coordinates = " +
        ll.latitude.toString() +
        ", " +
        ll.longitude.toString());
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        icon: BitmapDescriptor.fromBytes(mySiteMarkerIcon),
        position: ll,
      );
      _markers.add(_destination!);
      _layersIconRightFlow = 0;
      _layersIconBottomFlow = 170;
      _selectedLocation = ll;
      _addPadding = -20;
      _buttonPadding = 80;
      _bottomPadding = 50;
    });
  }

  double _roundTo5(double? value) {
    if (value == null) return 0;
    return ((value * pow(10, 5)).round().toDouble() / pow(10, 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Scaffold(
            body: GoogleMap(
              mapType: MapPreferences.getMapType(),
              compassEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: MapPreferences.getLocation(),
                zoom: _zoomState,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onLongPress: _addMe,
              onTap: _changeTapScreen,
              onCameraMove: _onZoomChanged,
              markers: _markers,
            ),
            floatingActionButton: AnimatedContainer(
              duration: Duration(milliseconds: _speed),
              padding: EdgeInsets.only(
                bottom: _buttonPadding,
              ),
              child: FloatingActionButton(
                child: _findMe,
                onPressed: () {
                  _switchMyLocation();
                  if (_activatedSearch) getLocation();
                },
              ),
            )),
        SearchBar(
          bottomPadding: _bottomPadding,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: _speed),
          bottom: _layersIconBottomFlow,
          right: -_layersIconRightFlow,
          child: Container(
              child: RawMaterialButton(
            onPressed: () {
              setState(() {
                if (_mapType == MapType.normal) {
                  _mapType = MapType.satellite;
                  MapPreferences.setMapType("satellite");
                } else {
                  _mapType = MapType.normal;
                  MapPreferences.setMapType("normal");
                }
              });
            },
            elevation: 2.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.layers,
              size: 27.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          )),
        ),
        if (_selectedLocation != null)
          AnimatedPositioned(
              duration: Duration(milliseconds: _speed),
              bottom: _addPadding,
              child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  duration: Duration(milliseconds: _speed),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          "Coordinates",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Arial",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${_roundTo5(_selectedLocation?.latitude)},  ${_roundTo5(_selectedLocation?.longitude)}',
                                        style: TextStyle(
                                            fontSize: 14, fontFamily: "Arial"),
                                      ),
                                    ]),
                                  ),
                                  Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: TextButton(
                                            onPressed: () {
                                              MapPreferences.setLocation(
                                                  _selectedLocation!);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddScreen(
                                                          coor:
                                                              _selectedLocation!,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              "Add +",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Arial",
                                                  fontSize: 17),
                                            ),
                                          )))
                                ],
                              )
                            ],
                          )))))
      ]),
      /*bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xff699BF7),
          onTap: (index) {},
          items: <Widget>[
            Icon(Icons.location_on, size: 30),
            Icon(HomePageIcons.compass, size: 30),
            Icon(Icons.bookmarks, size: 30),
          ]),*/
    );
  }
}
