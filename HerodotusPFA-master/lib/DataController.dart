import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  Future getData(String sites) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firebaseFirestore.collection(sites).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('sites')
        .where('name', isGreaterThanOrEqualTo: queryString)
        .get();
  }
}
