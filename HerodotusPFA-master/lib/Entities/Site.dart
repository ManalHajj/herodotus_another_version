import 'dart:io';

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
}
