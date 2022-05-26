import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:map/DataController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'Entities/Site.dart';
import 'home_page_icons_icons.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  //late QuerySnapshot snapshotData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('                             Feed',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.black),
        ),
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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: NetworkImage(
                                snapshot.data!.docs[index].data()['images'][0]),
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
                                'Username here',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
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
                                color: Colors.black,
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
                  );
                });
          }),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xff699BF7),
          onTap: (index) {},
          items: <Widget>[
            Icon(Icons.location_on, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.person, size: 30),
          ]),
    );
  }
}
