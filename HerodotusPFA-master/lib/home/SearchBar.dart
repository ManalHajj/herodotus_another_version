import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final double bottomPadding;
  const SearchBar({Key? key, this.bottomPadding = 50}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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
