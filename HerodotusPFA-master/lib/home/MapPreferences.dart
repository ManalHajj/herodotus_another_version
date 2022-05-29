import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPreferences {
  static late SharedPreferences _preferences;

  static const String locationLatitudeKey = "latitude";
  static const String locationLongitudeKey = "longitude";
  static const String mapTypeKey = "mapType";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void setLocation(LatLng ll) async => await _preferences
          .setDouble(locationLatitudeKey, ll.latitude)
          .then((value) async {
        await _preferences.setDouble(locationLongitudeKey, ll.longitude);
      });

  static void setMapType(String type) async =>
      await _preferences.setString(mapTypeKey, type);

  static LatLng getLocation() {
    return LatLng(_preferences.getDouble(locationLatitudeKey) ?? 0,
        _preferences.getDouble(locationLongitudeKey) ?? 0);
  }

  static MapType getMapType() {
    String? type = _preferences.getString(mapTypeKey);
    return (type == "satellite") ? MapType.satellite : MapType.normal;
  }
}
