import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlacedetailsWidget extends StatefulWidget {
  @override
  _PlacedetailsWidgetState createState() => _PlacedetailsWidgetState();
}

class _PlacedetailsWidgetState extends State<PlacedetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/Herodotus.png"),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => {Navigator.pop(context)},
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.white70,
                      size: 70,
                    )),
              ),
              Container(
                  height: 550,
                  padding: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            //Colors.white70,
                            Colors.white70,
                            Color.fromARGB(255, 255, 255, 255),
                          ])),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text('Jasper park',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                height: 1.5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20),
                        child: RatingBar.builder(
                          glow: false,
                          itemSize: 30,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: Color.fromARGB(255, 243, 243, 243),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Color(0xFFF1C644),
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              // _rating = rating;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20),
                        child: RatingBar.builder(
                          glow: false,
                          itemSize: 30,
                          initialRating: 3,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return const Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Colors.red,
                                );
                              case 1:
                                return const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.redAccent,
                                );
                              case 2:
                                return const Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                              case 3:
                                return const Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.lightGreen,
                                );
                              default:
                                return const Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: Colors.green,
                                );
                            }
                          },
                          onRatingUpdate: (rating) {
                            setState(() {
                              //_danger = rating.round();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 30),
                        child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ac velit in nascetur pulvinar dignissim. Lectus elit odio hendrerit vel sed ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 14,
                            )),
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    ));
  }
}
