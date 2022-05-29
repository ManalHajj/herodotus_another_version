import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map/DataController.dart';
import 'package:map/Entities/Comment.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.siteId}) : super(key: key);

  final String siteId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> comments = [];
  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController commentController = TextEditingController();
  late QuerySnapshot snapshotData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //renderComments();
  }

  void renderComments() {
    DataController dataController = new DataController();
    dataController.getCommentsBySite(widget.siteId).then((value) {
      snapshotData = value;
      comments = [];

      for (int i = 0; i < snapshotData.docs.length; i++) {
        comments.add(new Comment(
          id: snapshotData.docs[i]['id'].toString(),
          userId: snapshotData.docs[i]['userId'].toString(),
          siteId: snapshotData.docs[i]['siteId'].toString(),
          content: snapshotData.docs[i]['content'].toString(),
          date: snapshotData.docs[i]['date'],
        ));
      }
    });
    comments.sort((a, b) {
      return a.date!.compareTo(b.date!);
    });

    print("here nbr comments " + comments.length.toString());
  }

  void _registerComment(String id) async {
    Comment comment = new Comment(
        id: id,
        userId: "",
        siteId: widget.siteId,
        content: commentController.text.trim(),
        date: Timestamp.now());

    saveCommentInfoToFirestore(comment);
  }

  Future saveCommentInfoToFirestore(Comment comment) async {
    FirebaseFirestore.instance.collection("comments").doc(comment.id).set({
      "id": comment.id,
      "content": comment.content,
      "siteId": comment.siteId,
      "userId": comment.userId,
      "date": comment.date
    });

    print("My boo I am okey");
  }

  void saveComment() {
    if (commentController.text.isEmpty) return;
    _registerComment(Uuid().v1());
  }

  @override
  Widget build(BuildContext context) {
    renderComments();
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('siteId', isEqualTo: widget.siteId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: comments.length,
              itemBuilder: ((context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                                text: 'username  ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: snapshotData.docs[index]['content']
                                    .toString(),
                                style: TextStyle(color: Colors.black),
                              )
                            ])),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                DateFormat.yMMMd().format(
                                    snapshotData.docs[index]['date'].toDate()),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }));
        },
      ),
      /*body: ListView.builder(
          itemCount: comments.length,
          itemExtent: 100,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return Container(
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
                            text: 'username',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: comments[index].content,
                            style: TextStyle(color: Colors.black),
                          )
                        ])),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),*/

      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(
                    // user.photoURL!
                    'https://images.unsplash.com/photo-1653750775155-26364ac47832?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80'),
                radius: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                      hintText: 'Comment as ', //${user.displayName}
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                saveComment();
                commentController.text = "";
                renderComments();
              },
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
