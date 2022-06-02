import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Details/DetailsScreen.dart';
import 'Site.dart';

class Boomarks extends StatefulWidget {
  const Boomarks({Key? key}) : super(key: key);

  @override
  State<Boomarks> createState() => _BoomarksState();
}

class _BoomarksState extends State<Boomarks> {
  Site makeSite(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap, int index) {
    GeoPoint gp = snap.data!.docs[index]['coordinates'];
    List<String> imageList = [];
    snap.data!.docs[index]['images'].forEach((element) {
      imageList.add(element.toString());
    });

    print("images " + imageList.length.toString());
    return new Site(
      address: snap.data!.docs[index]['address'],
      coordinates: LatLng(gp.latitude, gp.longitude),
      danger: snap.data!.docs[index]['danger'],
      description: snap.data!.docs[index]['description'],
      id: snap.data!.docs[index]['id'],
      images: imageList,
      title: snap.data!.docs[index]['title'],
      rating: snap.data!.docs[index]['rating'],
      reported: snap.data!.docs[index]['reported'],
    );
  }

  final user = FirebaseAuth.instance.currentUser!;
  var _value;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: getAppbar(),
        preferredSize: Size.fromHeight(0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Bookmarks",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemExtent: 350,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                          site: makeSite(snapshot, index),
                                        )),
                              );
                            },
                            child: Container(
                              width: size.width / 2,
                              height: size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: NetworkImage(snapshot
                                          .data!.docs[index]
                                          .data()['saved'][0]),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black26, BlendMode.darken))),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
