import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:restless/HiddenDrawer/hidden_drawer.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/MusicLibrary/artist_data.dart';
import 'package:restless/music_provider.dart';


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

  

  


  @override
  initState() {
    super.initState();
    // await MusicProvider.of(context).;
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

    MusicProvider.of(context).artists = artists;
    // _ftr.then((f)=>ArtistsPageProvider.of(context).artists = artists);
    
    for(int i = 0; i < MusicProvider.of(context).artists.length ; i++)
    {
      MusicProvider.of(context).artists[i].albums.sort( (a, b) => a.name.compareTo(b.name));// sort albums
    }


    return StreamBuilder(
      stream: MusicProvider.of(context).artistStreamCtrl.stream,
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
          
        );
      },
    );
  }
}