import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class HomeMap extends StatefulWidget {
  final bool tapedScreen;

  const HomeMap({Key? key, this.tapedScreen = false}) : super(key: key);

  @override
  _HomeMapState createState() => _HomeMapState();

  void set tapedScreen(bool tapedScreen) {
    this.tapedScreen = tapedScreen;
  }
}

class _HomeMapState extends State<HomeMap> {
  double _zoomState = 11.5;
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  late Uint8List markerIcon;
  late Uint8List lastPosMarkerIcon;
  //late Marker marker;
  StreamSubscription<LocationData>? _locationListener = null;

  bool _activatedSearch = true;
  Icon _findMe = Icon(
    Icons.my_location,
    color: Colors.white,
  );

  void getLocation() async {
    //var location = await currentLocation.getLocation();
    lastPosMarkerIcon =
        await getBytesFromAsset("assets/images/lastPosMarker.png", 100);
    markerIcon = await getBytesFromAsset("assets/images/marker.png", 100);
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
    print("Hey yo here again");
    widget.tapedScreen = !widget.tapedScreen;
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
  }

  void _addMe(LatLng ll) {
    print("coordinates = " +
        ll.latitude.toString() +
        ", " +
        ll.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          compassEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: const LatLng(37.773972, -122.431297),
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
        floatingActionButton: Container(
          padding: const EdgeInsets.only(
            bottom: 80,
          ),
          child: FloatingActionButton(
            child: _findMe,
            onPressed: () {
              _switchMyLocation();
              if (_activatedSearch) getLocation();
            },
          ),
        ));
  }
}
