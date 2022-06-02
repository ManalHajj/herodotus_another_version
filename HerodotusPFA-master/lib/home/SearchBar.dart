import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/DataController.dart';

import '../Entities/Site.dart';
import 'HomePage.dart';

class SearchBar extends StatefulWidget {
  final double bottomPadding;
  const SearchBar({Key? key, this.bottomPadding = 50}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController searchController = TextEditingController();
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  DataController dataController = new DataController();

  Future<void> showTheseSites(String queryText) async {
    dataController.queryData(queryText).then((value) {
      snapshotData = value;
      return mapToSite();
    }).then((value) {
      return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  siteList: value,
                )),
      );
    });
  }

  List<Site> mapToSite() {
    List<Site> sites = [];

    print("here I am " + snapshotData.docs.length.toString());
    snapshotData.docs.forEach((snap) {
      sites.add(Site.queryToSite(snap));
    });

    print("here ; " + sites.length.toString());

    return sites;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 250),
        top: widget.bottomPadding,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextField(
            cursorHeight: 20,
            cursorColor: const Color(0xFF44AEF4),
            onSubmitted: (queryText) {
              showTheseSites(queryText);
            },
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(
                Icons.search,
                size: 24.0,
              ),
              fillColor: const Color.fromRGBO(220, 220, 220, 0.7),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Find a site',
            ),
          ),
        ));
  }
}
