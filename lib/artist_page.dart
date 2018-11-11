import 'dart:typed_data';
import 'dart:collection';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/album_art_area.dart';
import 'package:restless/artist_data.dart';
import 'package:restless/artist_sliver.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/now_playing_menu.dart';
import 'package:restless/track_info_area.dart';


class ArtistPage extends StatefulWidget
{
  List<ArtistData> artists;
  ScrollController scrl;

  ArtistPage({
    Key key,
    @required this.artists,
    this.scrl,
  }) : super(key: key);

  @override
  ArtistPageState createState() {
    return new ArtistPageState();
  }
}

class ArtistPageState extends State<ArtistPage> {

  @override
  Widget build(BuildContext context) {
    print('artistPage');

    for(int i = 0; i < widget.artists.length ; i++)
    {
      widget.artists[i].albums.sort( (a, b) => a.name.compareTo(b.name));// sort albums
    }

    for(int i = 0; i < widget.artists.length ; i++)
    {
      for(int j = 0; j < widget.artists[i].albums.length ; j++)
      {
        print(widget.artists[i].albums[j].name);
      }
      print('\n');
    }

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

          child: ListView.builder(
            controller: widget.scrl,
            itemCount: widget.artists.length,
            itemBuilder: (BuildContext context, int index) {
              return ArtistSliver(
                artist: widget.artists[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
