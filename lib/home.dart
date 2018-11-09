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
  String _path = '/storage/emulated/0/Music/TestMusic/Carousel Casualties/Madison/Bright Red Lights.mp3';
  bool _playing = false;

  Future _getAlbumInfo(String artist, String path) async
  {


    TagProcessor tp = TagProcessor();
    File f = File(path);
    var img = await tp.getTagsFromByteArray(f.readAsBytes());

    ImageProvider albumArt;
    if(img.last.tags['APIC'] == null)
    {
      print('Problems with: ' + artist);
      print('::: ' + path.toString());
      return;
    }

    if(artists[artist] == null)
      artists[artist] = [];

    albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;
    artists[artist].add(albumArt);

    print('added ' + path.split('/')[7]);

  }

  @override
  void initState() {
    print(Directory('storage/emulated/0/Music/TestMusic').listSync());
    for( Directory artist in Directory('/storage/emulated/0/Music/TestMusic').listSync() )
    {
      for( var album in artist.listSync())
      {
        print('adding ' + album.path.substring(album.path.lastIndexOf('/')+1, album.path.length));
        for( var file in Directory(album.path).listSync())
        {

          if(file.path.contains('.mp3')) {
            print(Directory(album.path).listSync());
            _getAlbumInfo(artist.toString().substring(artist.toString().lastIndexOf('/')+1, artist.toString().length-1),file.path);
            break;
          }
        }
      }
    }
  }

  AudioPlayer audioPlayer = new AudioPlayer();
  @override
  Widget build(BuildContext context)
  {

    audioPlayer.setUrl(_path, isLocal: true);
    audioPlayer.setReleaseMode(ReleaseMode.STOP);

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