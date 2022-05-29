import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:map/Entities/Comment.dart';
import 'package:map/Entities/Site.dart';
import 'package:map/home/MapPreferences.dart';

import '../home/HomePage.dart';
import '../my_flutter_app_icons.dart';
import 'Animated_detail_header.dart';
import 'Comments.dart';
//import 'my_flutter_app_icons.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key, required this.site}) : super(key: key);
  final Site site;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
                          site: widget.site,
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
                              child: GestureDetector(
                                onTap: () {
                                  MapPreferences.setLocation(
                                      widget.site.coordinates!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                              siteList: <Site>[widget.site],
                                            )),
                                  );
                                },
                                child: Text(
                                  widget.site.address!,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Outfit',
                                      fontSize: 17),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                          widget.site.description!,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                            padding: EdgeInsets.only(left: 40, top: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                          siteId: widget.site.id!,
                                        )),
                              );
                            },
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
