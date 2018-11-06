import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/album_art_area.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/now_playing_menu.dart';
import 'package:restless/track_info_area.dart';


class ArtistPage extends StatefulWidget
{
  @override
  ArtistPageState createState() {
    return new ArtistPageState();
  }
}

class ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              //TODO: sort by alphabet
            },
          ),
        ],
        backgroundColor: Colors.black,
        title: RichText(
          text: TextSpan(
            text: 'Artists',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        centerTitle: true,

      ),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.black,
                    child: ListView(
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          height: double.maxFinite,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/assets/art20.jpg'),
                            ),
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/assets/art4.jpg'),
                            ),
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/assets/art12.jpg'),
                            ),
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/assets/art5.jpg'),
                            ),
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('lib/assets/art8.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.black,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.deepPurple,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.redAccent,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 125.0,
                    color: Colors.lightBlue,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Artist Name',
                    style: TextStyle(
                      color: Colors.white,
                      background: Paint(),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      height: 1.0
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
