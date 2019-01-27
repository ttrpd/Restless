import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:restless/Artists/artist_page.dart';
import 'package:restless/HiddenDrawer/hidden_drawer.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/artist_data.dart';
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
  Future _ftr;

  Set<TrackTag> extractBasicTags(Map<String, dynamic> tags, String trackName)
  {
    Set<TrackTag> tagOutput = Set<TrackTag>();
    tagOutput.add(TrackTag(name: 'name', content: trackName));
    tagOutput.add(TrackTag(name: 'artist', content: tags['TPE2'].trim()));
    tagOutput.add(TrackTag(name: 'album', content: tags['album'].trim()));
    tagOutput.add(TrackTag(name: 'number', content: tags['track'].trim()));
    return tagOutput;
  }

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
          String name = (img.last.tags['title']!=null)?img.last.tags['title'].trim():entity.path.split('/').last.substring(0,entity.path.split('/').last.indexOf('.')).trim();

          TrackData track = TrackData(
            name: name,
            path: entity.path,
            tags: extractBasicTags(img.last.tags, name),
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
      if(NowPlayingProvider.of(context).track != NowPlayingProvider.of(context).playQueue.last)
      {
        if(NowPlayingProvider.of(context).trackFlow == TrackFlow.shuffle)
        {
          NowPlayingProvider.of(context).randomTrack();
        }
        else
        {
          NowPlayingProvider.of(context).nextTrack();
        }
        setState(() {
          NowPlayingProvider.of(context).playCurrentTrack();
        });
      }
      else
      {
        switch (NowPlayingProvider.of(context).trackFlow) 
        {
          case TrackFlow.natural:
            setState(() {
              NowPlayingProvider.of(context).playing = false;              
            });
            break;
          case TrackFlow.shuffle:
            NowPlayingProvider.of(context).randomTrack();
            NowPlayingProvider.of(context).playCurrentTrack();
            break;
          case TrackFlow.repeat:
            NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
            NowPlayingProvider.of(context).playCurrentTrack();
            break;
          case TrackFlow.repeatOnce:
            NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(0);
            NowPlayingProvider.of(context).playCurrentTrack();
            NowPlayingProvider.of(context).trackFlow = TrackFlow.natural;
            break;
        }
      }
      
      setState(() {
        NowPlayingProvider.of(context).trackProgressPercent = 1.0;
      });
      
    };

    NowPlayingProvider.of(context).audioPlayer.setReleaseMode(ReleaseMode.STOP);

    artists.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()) );

    ArtistsPageProvider.of(context).artists = artists;
    // _ftr.then((f)=>ArtistsPageProvider.of(context).artists = artists);
    
    for(int i = 0; i < ArtistsPageProvider.of(context).artists.length ; i++)
    {
      ArtistsPageProvider.of(context).artists[i].albums.sort( (a, b) => a.name.compareTo(b.name));// sort albums
    }

    double artistsListOffset = 0.0;

    double sliverHeight = ((MediaQuery.of(context).size.height*57) / MediaQuery.of(context).size.width);//(MediaQuery.of(context).size.height * 0.145);


    return FutureBuilder(
      future: _ftr,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        for(int i = 0; i < artists.length ;i++)
        {
          artists[i].albums.sort( (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));// sort albums
          for(int j = 0; j < artists[i].albums.length; j++)
          {
            artists[i].albums[j].songs.sort( (a, b) => int.parse(a.tags.firstWhere((a)=>a.name == 'number').content) - int.parse(b.tags.firstWhere((a)=>a.name == 'number').content));
          }
        }
        return HiddenDrawer(
          artists: ArtistPage(
            getOffset: () => artistsListOffset,
            setOffset: (offset) => artistsListOffset = offset,
            sliverHeight: sliverHeight,
            dragMenu: (DragUpdateDetails d){},
          ),
          albums: Container(color: Colors.green[100],),
          nowPlaying: ClipRect(child: NowPlaying(audioPlayer: NowPlayingProvider.of(context).audioPlayer,)),
          playlists: Container(color: Colors.blue[100],),
          settings: Container(color: Colors.amber[100],),
        );
      },
    );
  }
}

// ArtistPage(
//   getOffset: () => artistsListOffset,
//   setOffset: (offset) => artistsListOffset = offset,
//   sliverHeight: sliverHeight,
//   dragMenu: (DragUpdateDetails d){},
// ),