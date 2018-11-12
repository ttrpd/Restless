
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/NowPlaying/album_art_area.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/now_playing_menu.dart';
import 'package:restless/NowPlaying/track_info_area.dart';
import 'package:restless/now_playing_provider.dart';


class NowPlaying extends StatefulWidget
{
  String path;
  AudioPlayer audioPlayer;

  NowPlaying({
    Key key,
    @required this.path,
    @required this.audioPlayer,
  }) : super(key: key);

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> with SingleTickerProviderStateMixin
{

  @override
  void initState()
  {
    _getTrackInfo(widget.path);
  }


  Future _getTrackInfo(String path) async {
    TagProcessor tp = TagProcessor();
    File f = File(path);
    var img = await tp.getTagsFromByteArray(f.readAsBytes());


    setState(() {
      track = img.last.tags['title'];
      album = img.last.tags['album'];
      artist = img.last.tags['artist'];
      albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
    });
    print('done');
  }

  ImageProvider albumArt;
  String artist;
  String album;
  String track;

//  double _blurValue = 0.0;
  double _trackProgressPercent = 0.0;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AlbumArtArea(blurValue: NowPlayingProvider.of(context).blurValue, img: albumArt,),//need to move this method call so that id doesn't rerun on build
                ],
              ),

              ListView(// info/control layer
                physics: ScrollPhysics(),
                children: <Widget>[

                  GestureDetector(// TrackInfoArea
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      //TODO: add animation curve based on scroll
                      setState(() {
                        if(NowPlayingProvider.of(context).blurValue > 0.0 && details.delta.dy < 0)NowPlayingProvider.of(context).blurValue -= 0.75;
                        if(NowPlayingProvider.of(context).blurValue < 15 && details.delta.dy > 0)NowPlayingProvider.of(context).blurValue += 0.75;
                      });
                    },
                    onVerticalDragEnd: (DragEndDetails details) {
                      setState(() {
                        if(NowPlayingProvider.of(context).blurValue < 8)
                          NowPlayingProvider.of(context).blurValue = 0.0;
                        else
                          NowPlayingProvider.of(context).blurValue = 15.0;
                      });
                    },
                    child: TrackInfoArea(blurValue: NowPlayingProvider.of(context).blurValue, name: track, album: album, artist: artist, path: widget.path),
                  ),
                  NowPlayingMenu(
                    audioPlayer: widget.audioPlayer,
                    trackProgressPercent: _trackProgressPercent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
