import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/artist_data.dart';
import 'package:restless/Artists/artist_page.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/Artists/artists_page_provider.dart';


class Home extends StatefulWidget
{


  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {

  List<ArtistData> artists = new List<ArtistData>();
  String _musicDirectoryPath = '/storage/emulated/0/Music/TestMusic';//'/storage/emulated/0/Music/TestMusic';
  String _path = '/storage/emulated/0/Music/TestMusic/Carousel Casualties/Madison/Bright Red Lights.mp3';
  double artistsListOffset = 0.0;
  Future _ftr;

  Future _getMusicData(String directoryPath) async 
  {
    List<FileSystemEntity> dirs = Directory(directoryPath).listSync();
    dirs.removeWhere((fse)=>fse==null);
    for(FileSystemEntity entity in dirs)
    {
      if(entity == null)
      {
        print('Entity was null');
        break;
      }
      else if(entity is Directory)
      {
        _getMusicData(entity.path);// recurse
      }
      else
      {
        if(entity.path.contains('.mp3'))
        {
          TagProcessor tp = TagProcessor();
          // File f = File(entity.path);
          var img = await tp.getTagsFromByteArray(File(entity.path).readAsBytes());
          // print(img.toString());
          // print(img.last.tags);
          if(img.last.tags != null && img.last.tags['APIC'] != null)
          {
            // print('trying to add'+img.last.tags['album']+' by '+img.last.tags['artist']);
            ImageProvider albumArt;
            albumArt = Image.memory(Uint8List.fromList(img.last.tags['APIC'].imageData)).image;

            print(img.last.tags);
            TrackData track = TrackData(
              name: img.last.tags['title'].trim(), 
              path: entity.path, 
              tags: img.last.tags,
              artistName: img.last.tags['artist'].trim(),
              albumName: img.last.tags['album'].trim(), 
              albumArt: albumArt
            );
            AlbumData album = AlbumData(name: track.albumName, albumArt: albumArt, songs: [track],);
            ArtistData artist = ArtistData(name: track.artistName,albums: [album],);

            if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == img.last.tags['artist'].toString().toUpperCase().trim(), orElse: ()=>null) == null)
            {
              artists.add(artist);
            }
            
            if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == img.last.tags['artist'].toString().toUpperCase().trim(), orElse: ()=>null)
              .albums.firstWhere( (al) => al.name.toUpperCase().trim() == img.last.tags['album'].toString().toUpperCase().trim(), orElse: ()=>null) == null)
            {
              artists.firstWhere( (a) => a.name.toUpperCase().trim() == img.last.tags['artist'].toString().toUpperCase().trim(), orElse: ()=>null)
              .albums.add(album);
            }

            if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == img.last.tags['artist'].toString().toUpperCase().trim(), orElse: ()=>null)
              .albums.firstWhere( (al) => al.name.toUpperCase().trim() == img.last.tags['album'].toString().toUpperCase().trim(), orElse: ()=>null)
              .songs.firstWhere( (s) => s.name.toUpperCase().trim() == img.last.tags['track'].toString().toUpperCase().trim(), orElse: ()=>null) == null)
            {
              artists.firstWhere( (a) => a.name.toUpperCase().trim() == img.last.tags['artist'].toString().toUpperCase().trim(), orElse: ()=>null)
              .albums.firstWhere( (al) => al.name.toUpperCase().trim() == img.last.tags['album'].toString().toUpperCase().trim(), orElse:()=>null)
              .songs.add(track);
            }
          }
          
          // return Future.delayed(Duration(milliseconds: 1));
        }
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _ftr = _getMusicData(_musicDirectoryPath);
    
    print('Initialized'); 
  }



  @override
  Widget build(BuildContext context)
  {
    // NowPlayingProvider.of(context).audioPlayer.setUrl(_path, isLocal: true);
    NowPlayingProvider.of(context).audioPlayer.setReleaseMode(ReleaseMode.STOP);

    artists.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) );//sort artists

    ArtistsPageProvider.of(context).artists = artists;
    // _ftr.then((f)=>ArtistsPageProvider.of(context).artists = artists);
    

    return FutureBuilder(
      future: _ftr,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('building future');
        for(int i = 0; i < artists.length ;i++)
        {
          artists[i].albums.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));// sort albums
          for(int j = 0; j < artists[i].albums.length; j++)
          {
            artists[i].albums[j].songs.sort( (a, b) => a.tags['track'].toString().compareTo(b.tags['track'].toString()));
          }
        }
        return PageView(
          pageSnapping: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ArtistPage(
              getOffset: () => artistsListOffset,
              setOffset: (offset) => artistsListOffset = offset,
            ),
            NowPlaying(audioPlayer: NowPlayingProvider.of(context).audioPlayer,),
          ],
        );
      },
    );
  }
}