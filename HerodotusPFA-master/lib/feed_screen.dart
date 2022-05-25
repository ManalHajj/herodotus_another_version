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

import 'home_page_icons_icons.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: ListView.builder(
          //itemCount: snapshotData.docs.length,
          itemExtent: 350,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            // final place = snapshotData?.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://www.maroc-hebdo.press.ma/files/2015/12/casa.jpg'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black26, BlendMode.darken))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(//users image
                          'https://shonakid.de/wp-content/uploads/2018/09/Killua-killua-zoldyck-2011-34976283-1280-720.jpg'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'username here',
                          style: TextStyle(color: Colors.black),
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
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      'name of site here',
                      textAlign: TextAlign.center,

                      //place[index]['name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Metropolis',
                          fontSize: 24),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.star),
                          label: Text('rating here'
                              //place[index]['rating']
                              ))
                    ],
                  )
                ],
              ),
            );
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
