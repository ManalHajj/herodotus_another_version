import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Site {
  String? id;
  String? title;
  String? address;
  double? rating;
  int? danger;
  String? description;
  LatLng? coordinates;
  List<String>? images;
  int? reported;

  Site(
      {this.id,
      this.title,
      this.address,
      this.rating,
      this.danger,
      this.description,
      this.coordinates,
      this.images,
      this.reported});

  @override
  String toString() {
    return id.toString() + " " + title.toString();
  }

  static Site queryToSite(QueryDocumentSnapshot<Object?> snap) {
    GeoPoint gp = snap['coordinates'];
    List<String> imageList = [];
    snap['images'].forEach((element) {
      imageList.add(element.toString());
    });

    return new Site(
      address: snap['address'],
      coordinates: LatLng(gp.latitude, gp.longitude),
      danger: snap['danger'],
      description: snap['description'],
      id: snap['id'],
      images: imageList,
      title: snap['title'],
      rating: snap['rating'],
      reported: snap['reported'],
    );
  }

  Future<Marker?> siteToMarker(BitmapDescriptor bitmapDescriptor) async {
    if (this.title == null && this.coordinates == null) return null;
    return Marker(
      icon: bitmapDescriptor,
      markerId: MarkerId(this.title!),
      position: this.coordinates!,
    );
  }
}
