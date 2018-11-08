import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';
import 'package:restless/artist_page.dart';
import 'package:restless/my_scroll_behavior.dart';
import 'package:restless/now_playing_page.dart';

class Home extends StatefulWidget
{


  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {


  Map<String, List<ImageProvider>> artists = {'':[]};
  String _path = '/storage/emulated/0/Music/TestMusic/Mike Krol/I Hate Jazz/Fifteen Minutes.mp3';
  bool _playing = false;

  Future _getAlbumInfo(String artist, String path) async
  {

    String songPath = Directory(path).listSync().first.path;
    TagProcessor tp = TagProcessor();
    File f = File(songPath);
    var img = await tp.getTagsFromByteArray(f.readAsBytes());

    ImageProvider albumArt;
    if(img.last.tags['APIC'] == null)
      return;

    artists[artist] = [];
    albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;

    artists[artist].add(albumArt);
    print(albumArt.toString());
  }

//  Future _getTrackInfo(String path) async {
//    TagProcessor tp = TagProcessor();
//    File f = File(path);
//    var img = await tp.getTagsFromByteArray(f.readAsBytes());
//
//    setState(() {
//      track = img.last.tags['title'];
//      album = img.last.tags['album'];
//      artist = img.last.tags['artist'];
//      albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
//    });
//    print(img.last.tags['APIC'].description);
//    print('done');
//  }

  AudioPlayer audioPlayer = new AudioPlayer();
  @override
  Widget build(BuildContext context)
  {

    audioPlayer.setUrl(_path, isLocal: true);
    audioPlayer.setReleaseMode(ReleaseMode.STOP);

//    print(Directory('/storage/emulated/0/Music/TestMusic').listSync());
    for( Directory artist in Directory('/storage/emulated/0/Music/TestMusic').listSync() )
    {
      print('-----'+artist.path.substring(artist.path.lastIndexOf('/')+1, artist.path.length));
      for( var album in artist.listSync())
      {
        if(!album.toString().contains('.ini') && !album.toString().contains('.jpg') && !album.toString().contains('.png'))
        {
          print('adding ' + album.path.substring(album.path.lastIndexOf('/')+1, album.path.length));
          _getAlbumInfo(artist.toString().substring(artist.toString().lastIndexOf('/')+1, artist.toString().length-1),album.path);
        }
      }
    }

    print(artists);
    artists.remove('');

    return PageView(
      pageSnapping: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        ArtistPage(artists: artists,),
        NowPlaying(audioPlayer: audioPlayer, path: _path, playing: _playing,),
      ],
    );
  }
}