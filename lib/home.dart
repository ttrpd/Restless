import 'dart:collection';
import 'dart:convert';
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
  String _musicDirectoryPath = '/storage/emulated/0/Music';//'/storage/emulated/0/Music/TestMusic';
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
      else if(entity.path.contains('.mp3'))
      {
        TagProcessor tp = TagProcessor();
        var img = await tp.getTagsFromByteArray(File(entity.path).readAsBytes());
        if(img.last.tags != null && img.last.tags['APIC'] != null)
        {
          // AttachedPicture
          ImageProvider albumArt;
          albumArt = Image.memory(base64.decode(img.last.tags['APIC'].imageData64)).image;

          TrackData track = TrackData(
            name: (img.last.tags['title']!=null)?img.last.tags['title'].trim():entity.path.split('/').last.substring(0,entity.path.split('/').last.indexOf('.')).trim(), 
            path: entity.path, 
            tags: img.last.tags,
            artistName: img.last.tags['TPE2'].trim(),
            albumName: img.last.tags['album'].trim(), 
            albumArt: albumArt
          );
          AlbumData album = AlbumData(name: track.albumName, albumArt: albumArt, songs: [track],);
          ArtistData artist = ArtistData(name: track.artistName, albums: [album],);
          print(artist.name + " - " + album.name);
          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.add(artist);
          }
          
          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.add(album);
          }

          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse: ()=>null)
            .songs.firstWhere( (s) => s.name.toUpperCase().trim() == track.name.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse:()=>null)
            .songs.add(track);
          }
        }
        
        // return Future.delayed(Duration(milliseconds: 1));
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

    NowPlayingProvider.of(context).audioPlayer.durationHandler = (Duration d) {
      if(NowPlayingProvider.of(context).endTime != null)
        setState(() {
          NowPlayingProvider.of(context).endTime = d;
        });
    };
    
    NowPlayingProvider.of(context).audioPlayer.positionHandler = (Duration d) {
      setState(() {
        NowPlayingProvider.of(context).currentTime = d;
      });
      NowPlayingProvider.of(context).trackProgressPercent = NowPlayingProvider.of(context).currentTime.inMilliseconds / NowPlayingProvider.of(context).endTime.inMilliseconds;
    };
    
    NowPlayingProvider.of(context).audioPlayer.completionHandler = () {
      if(NowPlayingProvider.of(context).playQueue != null)
      {
        // if(NowPlayingProvider.of(context).playQueue.elementAt(0).path.toString() == '')
        //   print('Path was null');

        NowPlayingProvider.of(context).audioPlayer.play(
          NowPlayingProvider.of(context).playQueue.elementAt(0).path
        );
        setState(() {
          NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
        });
        NowPlayingProvider.of(context).playedQueue.add(NowPlayingProvider.of(context).playQueue.elementAt(0));        
        NowPlayingProvider.of(context).playQueue.removeAt(0);
        NowPlayingProvider.of(context).playing = true;
      }
      else
      {
        NowPlayingProvider.of(context).playing = false;
      }
      
      setState(() {
        NowPlayingProvider.of(context).trackProgressPercent = 1.0;
      });
      
    };

    // NowPlayingProvider.of(context).audioPlayer.setUrl(_path, isLocal: true);
    NowPlayingProvider.of(context).audioPlayer.setReleaseMode(ReleaseMode.STOP);

    artists.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) );

    ArtistsPageProvider.of(context).artists = artists;
    // _ftr.then((f)=>ArtistsPageProvider.of(context).artists = artists);
    

    return FutureBuilder(
      future: _ftr,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        
        for(int i = 0; i < artists.length ;i++)
        {
          artists[i].albums.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));// sort albums
          for(int j = 0; j < artists[i].albums.length; j++)
          {
            artists[i].albums[j].songs.sort( (a, b) => int.parse(a.tags['track'].toString()) - int.parse(b.tags['track'].toString()));
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