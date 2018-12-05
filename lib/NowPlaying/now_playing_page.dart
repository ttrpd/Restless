import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/NowPlaying/album_art_area.dart';
import 'package:restless/artist_data.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/NowPlaying/now_playing_menu.dart';
import 'package:restless/NowPlaying/track_info_area.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';


class NowPlaying extends StatefulWidget
{
  AudioPlayer audioPlayer;

  NowPlaying({
    Key key,
    @required this.audioPlayer,
  }) : super(key: key);

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> with SingleTickerProviderStateMixin
{

  @override
  void initState() {
    super.initState();
  }

  // Future _getTrackInfo(String path) async {
  //   TagProcessor tp = TagProcessor();
  //   File f = File(path);
  //   var img = await tp.getTagsFromByteArray(f.readAsBytes());


  //   setState(() {
  //     track = img.last.tags['title'];
  //     NowPlayingProvider.of(context).album = img.last.tags['album'];
  //     NowPlayingProvider.of(context).artist = img.last.tags['artist'];
  //     NowPlayingProvider.of(context).albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
  //   });
  // }

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
                  AlbumArtArea(blurValue: NowPlayingProvider.of(context).blurValue, img: (NowPlayingProvider.of(context).track==null)?null:NowPlayingProvider.of(context).track.albumArt,),
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
                      name: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.name,
                      album: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.albumName,
                      artist: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.artistName, 
                      path: (NowPlayingProvider.of(context).track==null)?'':NowPlayingProvider.of(context).track.path,//'/storage/emulated/0/Music/TestMusic/Carousel Casualties/Madison/Bright Red Lights.mp3',
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
