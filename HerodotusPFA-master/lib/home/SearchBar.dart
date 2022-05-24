import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map/DataController.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget searchData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(snapshotData.docs[index]['image']),
            ),
            title: Text(
              snapshotData.docs[index]['name'],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              isExecuted = false;
            });
          }),

      /*duration: Duration(milliseconds: 250),
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
              decoration: InputDecoration(
                isDense: true,
                fillColor: const Color.fromRGBO(220, 220, 220, 0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintText: 'Find a site',
              ),*/
      appBar: AppBar(
        actions: [
          GetBuilder<DataController>(
              init: DataController(),
              builder: (val) {
                return IconButton(
                  onPressed: () {
                    val.queryData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                      });
                    });
                  },
                  icon: Icon(Icons.search),
                );
              })
        ],
        title: TextField(
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Find a site',
          ),
          controller: searchController,
        ),
      ),
      body: isExecuted ? searchData() : HomePage(),
    );
  }
}
