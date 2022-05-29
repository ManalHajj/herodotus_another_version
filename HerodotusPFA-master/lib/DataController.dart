import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    return await FirebaseFirestore.instance.collection(collection).get();
  }

  Future queryData(String queryString) async {
    print("site " + queryString);
    return await FirebaseFirestore.instance
        .collection('sites')
        .where('title', isGreaterThanOrEqualTo: queryString.trim())
        .where('title', isLessThanOrEqualTo: queryString.trim() + '\uf8ff')
        .get();
  }

  Future getCommentsBySite(String siteId) async {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('siteId', isEqualTo: siteId)
        .get();
  }

  Future getUserById(String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();
  }
}
