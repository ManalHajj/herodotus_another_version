import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:map/Details/DetailsScreen.dart';
import 'package:map/SideBar.dart';
import 'package:map/home/HomePage.dart';

import '../Entities/Site.dart';
//import 'home_page_icons_icons.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  //late QuerySnapshot snapshotData;

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

  var _value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Feed', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SideBar()),
            );
          },
          icon: const Icon(Icons.person, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(siteList: [])),
              );
            },
            icon: const Icon(Icons.map, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('sites').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data!.docs[index]
                                  .data()['images'][0]),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black26, BlendMode.darken))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(//users image
                                  'https://images.unsplash.com/photo-1605993439219-9d09d2020fa5?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manal Lalil',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Spacer(),
                            PopupMenuButton(
                                onSelected: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                                icon: Icon(Icons.more_horiz),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Text("Report"),
                                        value: "Report",
                                      ),
                                    ])
                            /* for admin :  
                           Spacer(),
                            IconButton(onPressed: (){
                  
                            }, icon: const Icon(Icons.more_horiz,
                            color: Colors.white)) ,*/
                          ]),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              //'Monument name here',

                              snapshot.data!.docs[index].data()['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Outfit',
                                  fontSize: 30),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  primary: Color.fromARGB(255, 202, 202, 93),
                                  shape: const StadiumBorder(),
                                ),
                                icon: const Icon(Icons.star),
                                label: Text(
                                  snapshot.data!.docs[index]
                                      .data()['rating']
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Outfit',
                                      fontSize: 17),
                                ),
                                //label: Text(place[index]['rating'])
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
      /*bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xff699BF7),
          onTap: (index) {},
          items: <Widget>[
            Icon(Icons.location_on, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.person, size: 30),
          ]),*/
    );
  }
}
