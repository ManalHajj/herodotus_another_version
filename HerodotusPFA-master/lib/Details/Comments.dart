import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map/DataController.dart';
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

import '../Entities/Comment.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.siteId}) : super(key: key);

  final String siteId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> comments = [];

  final TextEditingController commentController = TextEditingController();
  late QuerySnapshot snapshotData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    renderComments();
  }

  void renderComments() {
    DataController dataController = new DataController();
    dataController.getCommentsBySite("").then((value) {
      snapshotData = value;

      for (int i = 0; i < snapshotData.docs.length; i++) {
        comments.add(new Comment(
          id: snapshotData.docs[i]['id'].toString(),
          userId: snapshotData.docs[i]['userId'].toString(),
          siteId: snapshotData.docs[i]['siteId'].toString(),
          content: snapshotData.docs[i]['content'].toString(),
        ));
      }
    });
  }

  void _registerComment(String id) async {
    Comment comment = new Comment(
      id: id,
      userId: "",
      siteId: widget.siteId,
      content: commentController.text.trim(),
    );

    saveCommentInfoToFirestore(comment);
  }

  Future saveCommentInfoToFirestore(Comment comment) async {
    FirebaseFirestore.instance.collection("sites").doc(comment.id).set({
      "id": comment.id,
      "content": comment.content,
      "siteId": comment.siteId,
      "userId": comment.userId,
    });

    print("My boo I am okey");
  }

  void saveComment() {
    _registerComment(Uuid().v1());
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 40,
            )),
        backgroundColor: Colors.white,
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1571844307880-751c6d86f3f3?ixlib=rb-1.2.1&raw_url=true&q=80&fm=jpg&crop=entropy&cs=tinysrgb&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=948'),
              radius: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: 'Lamiaa lalim',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' some description insert',
                      style: TextStyle(color: Colors.black),
                    )
                  ])),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL!), radius: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.displayName}',
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
