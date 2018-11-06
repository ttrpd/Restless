
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:restless/album_art_area.dart';
import 'package:restless/now_playing_menu.dart';
import 'package:restless/track_info_area.dart';


class Home extends StatefulWidget
{

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> with SingleTickerProviderStateMixin
{

  @override
  void initState()
  {
    _getTrackInfo(_path);
  }



  Future<List<Tag>> _getAlbumArt(String path) async{

    AttachedPicture pic;
    TagProcessor tp = TagProcessor();
    File f = File(path);
//    tp.getTagsFromByteArray(f.readAsBytes()).then((l) => pic = l.last.tags['APIC']);
    return  tp.getTagsFromByteArray(f.readAsBytes());
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

  double _blurValue = 0.0;
  bool _playing = false;
  double _trackProgressPercent = 0.0;
  AudioPlayer audioPlayer = new AudioPlayer();
  String _path = '/storage/emulated/0/Music/In The Key Of Sublimation/Zest.mp3';



  @override
  Widget build(BuildContext context) {
    audioPlayer.setUrl(_path, isLocal: true);
    audioPlayer.setReleaseMode(ReleaseMode.STOP);

    Future<List<Tag>> imgFuture;
    imgFuture = _getAlbumArt(_path);


    print('built');
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AlbumArtArea(blurValue: _blurValue, img: albumArt,),//need to move this method call so that id doesn't rerun on build
                ],
              ),

              ListView(// info/control layer
                physics: ScrollPhysics(),
                children: <Widget>[

                  GestureDetector(// TrackInfoArea
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      //TODO: add animation curve based on scroll
                      setState(() {
                        if(_blurValue > 0.0 && details.delta.dy < 0)_blurValue -= 0.75;
                        if(_blurValue < 15 && details.delta.dy > 0)_blurValue += 0.75;
                      });
                    },
                    onVerticalDragEnd: (DragEndDetails details) {
                      setState(() {
                        if(_blurValue < 8)
                          _blurValue = 0.0;
                        else
                          _blurValue = 15.0;
                      });
                    },
                    child: TrackInfoArea(blurValue: _blurValue, name: track, album: album, artist: artist, path: _path),
                  ),
                  NowPlayingMenu(
                    playing: _playing,
                    audioPlayer: audioPlayer,
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

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child, AxisDirection
      axisDirection) {
    return child;
  }
}
