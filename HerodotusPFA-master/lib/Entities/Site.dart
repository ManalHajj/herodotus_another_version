import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Site {
  String? id;
  String? name;
  double? rating;
  int? danger;
  String? description;
  LatLng? coordinates;
  List<File>? images;

  Site(
      {this.id,
      this.name,
      this.rating,
      this.danger,
      this.description,
      this.coordinates,
      this.images});
}
