// ignore: file_names

import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map/home/HomePage.dart';
import 'package:uuid/uuid.dart';

import '../Entities/Site.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoder/geocoder.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key, required this.coor}) : super(key: key);

  final LatLng coor;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  double _rating = 2.5;
  int _danger = 3;
  late final String _address;
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final Set<File> _images = {};
  final Set<String> _imagesUrl = {};

  void _getAdress() async {
    final coordinates =
        new Coordinates(widget.coor.latitude, widget.coor.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    _address = first.addressLine;
    print("adresse: " + _address);
  }

  @override
  void initState() {
    super.initState();
    _getAdress();
    print("PoPo " + widget.coor.latitude.toString());
  }

  Future saveAndGo() {
    saveAllInfos(Uuid().v1());
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                siteList: [],
              )),
    );
  }

  void _registerSite(String id) async {
    Site? site = new Site(
      id: id,
      title: _titleController.text,
      address: _address,
      rating: _rating,
      danger: _danger,
      description: _descriptionController.text,
      coordinates: new LatLng(widget.coor.latitude, widget.coor.longitude),
    );

    saveSiteInfoToFirestore(site);
  }

  Future saveSiteInfoToFirestore(Site site) async {
    print("lat here" + site.coordinates!.latitude.toString());
    GeoPoint gp =
        new GeoPoint(site.coordinates!.latitude, site.coordinates!.longitude);
    FirebaseFirestore.instance.collection("sites").doc(site.id).set({
      "id": site.id,
      "title": site.title!.trim(),
      "address": site.address!.trim(),
      "rating": (site.rating! * pow(10, 5)).round().toDouble() / pow(10, 5),
      "danger": site.danger,
      "description": site.description!.trim(),
      "coordinates": gp,
      "images": _imagesUrl.toList(),
      "savedSites": [],
      "user": "",
      "reported": 0
    });

    print("My boo I am okey");
  }

  void saveAllInfos(String id) {
    if (_images.isEmpty) {
      _registerSite(id);
      return;
    }

    _images.forEach((e) async {
      await uploadToStorage(Uuid().v4(), e)
          .whenComplete(() => _registerSite(id));
    });
  }

  Future<void> uploadToStorage(String imageName, File imageFile) async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref(imageName);
    firebase_storage.UploadTask uploadTask =
        storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() => null);

    await storageReference.getDownloadURL().then((urlImage) {
      print("My boo " + urlImage);
      _imagesUrl.add(urlImage);
    });
  }

  Future pickImage() async {
    try {
      final images = await ImagePicker().pickMultiImage();
      if (images == null) return;
      List<File> tempImages = [];
      for (var image in images) {
        tempImages.add(File(image.path));
      }
      setState(() {
        _images.addAll(tempImages);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takeImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      var tempImage = File(image.path);
      setState(() {
        _images.add(tempImage);
      });
    } on PlatformException catch (e) {
      print('Failed to take image: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Text _Label(String data) {
    return Text(
      data,
      style: const TextStyle(
        fontFamily: "Arial",
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container _container(Widget row) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: row);
  }

  Container _imageContainer(File image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Image.file(image),
    );
  }

  Widget _imagesList() {
    List<Widget> list = [];
    if (_images.isEmpty) {
      return const SizedBox.shrink();
    }
    for (var image in _images) {
      list.add(_imageContainer(image));
    }
    return Expanded(
        flex: 5,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: list,
          ),
        ));
  }

  Container _defaultImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: const Center(
          child: Icon(
        Icons.view_carousel,
        color: Color(0xFF44AEF4),
        size: 50,
      )),
    );
  }

  /*Column _defaultImage() {
    return Column(
      children: [
        Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 224, 222, 222)
                          .withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ]),
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () => takeImage(),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Color(0xFF44AEF4),
                  size: 50,
                ),
              ),
            )),
        Spacer(),
        Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 224, 222, 222)
                          .withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ]),
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () => pickImage(),
                child: const Icon(
                  Icons.picture_in_picture,
                  color: Color(0xFF44AEF4),
                  size: 50,
                ),
              ),
            ))
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                _imagesList(),
                Expanded(
                    child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () => {saveAndGo()},
                        child: const Text(
                          "Add +",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Arial",
                              fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () => takeImage(),
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Color(0xFF44AEF4),
                                size: 25,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () => pickImage(),
                              child: const Icon(
                                Icons.panorama,
                                color: Color(0xFF44AEF4),
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: _container(Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Expanded(child: _Label("Title:")),
                      Expanded(
                          flex: 3,
                          child: Container(
                              width: 300,
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: TextField(
                                controller: _titleController,
                                style: TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 20,
                                ),
                                cursorHeight: 22,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Accurate Title",
                                  hintStyle: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 20,
                                  ),
                                ),
                                /*BorderSide(
                            color: Colors.black,
                            width: 10.0,
                            style: BorderStyle.solid)*/
                              ))),
                    ]))),
                Expanded(
                    child: _container(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _Label("Rating:")),
                    Expanded(
                        flex: 3,
                        child: RatingBar.builder(
                          glow: false,
                          itemSize: 38,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: Color.fromARGB(255, 243, 243, 243),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Color(0xFFF1C644),
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        )),
                  ],
                ))),
                Expanded(
                    child: _container(Row(
                  children: [
                    Expanded(child: _Label("Danger rate:")),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: RatingBar.builder(
                            glow: false,
                            itemSize: 38,
                            initialRating: 3,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return const Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    color: Colors.red,
                                  );
                                case 1:
                                  return const Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent,
                                  );
                                case 2:
                                  return const Icon(
                                    Icons.sentiment_neutral,
                                    color: Colors.amber,
                                  );
                                case 3:
                                  return const Icon(
                                    Icons.sentiment_satisfied,
                                    color: Colors.lightGreen,
                                  );
                                default:
                                  return const Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                              }
                            },
                            onRatingUpdate: (rating) {
                              setState(() {
                                _danger = rating.round();
                              });
                            },
                          ),
                        ))
                  ],
                ))),
                const Divider(),
                Expanded(
                    flex: 3,
                    child: Container(
                        child: TextField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 1000,
                            style: TextStyle(
                              fontFamily: "Arial",
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: "What can you say about it?",
                                hintStyle: TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 20,
                                ),
                                counter: Offstage(),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderSide: BorderSide.none,
                                )))))
              ],
            )));
  }
}
