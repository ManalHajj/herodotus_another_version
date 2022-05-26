import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return await firebaseFirestore.collection(collection).get();
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('sites')
        .where('name', isGreaterThanOrEqualTo: queryString)
        .where('name', isLessThanOrEqualTo: queryString + '\uf8ff')
        .get();
  }
}
