
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/NowPlaying/album_art_area.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/now_playing_menu.dart';
import 'package:restless/NowPlaying/track_info_area.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';


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
      NowPlayingProvider.of(context).track = img.last.tags['title'];
      NowPlayingProvider.of(context).album = img.last.tags['album'];
      NowPlayingProvider.of(context).artist = img.last.tags['artist'];
      NowPlayingProvider.of(context).albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AlbumArtArea(blurValue: NowPlayingProvider.of(context).blurValue, img: NowPlayingProvider.of(context).albumArt,),//need to move this method call so that id doesn't rerun on build
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
                    child: TrackInfoArea(
                      blurValue: NowPlayingProvider.of(context).blurValue,
                      name: NowPlayingProvider.of(context).track, album: NowPlayingProvider.of(context).album,
                      artist: NowPlayingProvider.of(context).artist, path: widget.path
                    ),
                  ),
                  NowPlayingMenu(
                    audioPlayer: widget.audioPlayer,
                    trackProgressPercent: NowPlayingProvider.of(context).trackProgressPercent,
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
