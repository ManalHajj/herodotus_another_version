import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Animated_detail_header.dart';
import 'my_flutter_app_icons.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('sites').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BuilderPersistantDelegate(
                      maxExtent: MediaQuery.of(context).size.height,
                      minExtent: 240,
                      builder: (percent) {
                        return AnimatedDetailHeader(
                          topPercent: ((1 - percent) / .7.clamp(0.0, 1.0)),
                          bottomPercent: (percent / .3).clamp(0.0, 1.0),
                          snapshot: snapshot,
                        );
                      }),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.black26,
                            ),
                            Flexible(
                              child: Text(
                                snapshot.data!.docs[0].data()['address'],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Outfit',
                                    fontSize: 17),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          snapshot.data!.docs[0].data()['description'],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                            padding: EdgeInsets.only(left: 40, top: 30),
                            onPressed: () {},
                            icon: Icon(
                              MyFlutterApp.comments,
                              size: 30,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class BuilderPersistantDelegate extends SliverPersistentHeaderDelegate {
  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double percent) builder;

  BuilderPersistantDelegate(
      {required double maxExtent,
      required double minExtent,
      required this.builder})
      : _maxExtent = maxExtent,
        _minExtent = minExtent;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
