import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnimatedDetailHeader extends StatelessWidget {
  const AnimatedDetailHeader(
      {Key? key,
      required this.topPercent,
      required this.bottomPercent,
      required this.snapshot})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final double topPercent;
  final double bottomPercent;
  @override
  Widget build(BuildContext context) {
    final toPadding = MediaQuery.of(context).padding.top;
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: Padding(
            padding: EdgeInsets.only(
              top: (20 + toPadding) * (1 - bottomPercent),
              bottom: 160 * (1 - bottomPercent),
            ),
            child: Transform.scale(
              scale: lerpDouble(1, 1.3, bottomPercent)!,
              child: PlaceImagesPageView(snapshot: snapshot),
            ),
          ),
        ),
        Positioned.fill(
            top: null,
            bottom: -140 * (1 - topPercent),
            child: Container(
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          primary: Color.fromARGB(255, 202, 202, 93),
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(
                          Icons.star,
                          size: 40,
                        ),
                        label: Text(
                            snapshot.data!.docs[0].data()['rating'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Outfit',
                                fontSize: 20))),
                    TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 40,
                        ),
                        label: Text(
                            snapshot.data!.docs[0].data()['danger'].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Outfit',
                                fontSize: 20))),
                    const Spacer(),
                  ],
                ),
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 10,
          ),
        ),
        Positioned.fill(
            top: null,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(//users image
                        'https://images.unsplash.com/photo-1605993439219-9d09d2020fa5?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Username here',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
          top: lerpDouble(-30, 140, topPercent)!.clamp(toPadding + 10, 140),
          left: lerpDouble(60, 20, topPercent)!.clamp(20, 50),
          child: AnimatedOpacity(
            duration: kThemeAnimationDuration,
            opacity: bottomPercent < 1 ? 0 : 1,
            child: Text(
              snapshot.data!.docs[0].data()['title'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: lerpDouble(20, 40, topPercent),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PlaceImagesPageView extends StatelessWidget {
  const PlaceImagesPageView({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              itemCount: snapshot.data!.docs.length,
              physics: const BouncingScrollPhysics(),
              controller: PageController(viewportFraction: .9),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10)
                      ],
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!.docs[index].data()['images'][0],
                        ),
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.black26, BlendMode.darken),
                      )),
                );
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              snapshot.data!.docs.length,
              (index) => Container(
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 3,
                    width: 10,
                  )),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
