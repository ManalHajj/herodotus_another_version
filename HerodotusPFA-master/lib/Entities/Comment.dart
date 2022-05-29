import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String? userId;
  String? siteId;
  String? content;
  Timestamp? date;

  Comment({
    this.id,
    this.userId,
    this.siteId,
    this.content,
    this.date,
  });
}
