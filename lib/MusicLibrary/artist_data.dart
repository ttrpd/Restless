import 'package:flutter/material.dart';

class PlayList
{
  String name;
  List<TrackData> songs;

  PlayList({
    @required this.name,
    this.songs
  }){songs = new List<TrackData>();}
}

class ArtistData
{
  String name;
  List<AlbumData> albums;

  ArtistData({
    @required this.name,
    this.albums,
  }){albums = new List<AlbumData>();}
}

class AlbumData
{
  String name;
  String artistName;
  ImageProvider albumArt;
  List<TrackData> songs;

  AlbumData({
    @required this.name,
    this.artistName,
    this.albumArt,
    this.songs,
  }){songs = new List<TrackData>();}
}

class TrackData
{
  String name;
  String path;
  String artistName;
  String albumName;
  int number;
  ImageProvider albumArt = AssetImage('lib/assets/default.jpg');
  Set<TrackTag> tags = Set<TrackTag>();

  TrackData({
    this.path = '',
    this.name = '',
    this.tags,
    this.artistName = '',
    this.albumName = '',
    this.number = 0,
    this.albumArt,
  });

  operator ==(Object track)
  {
    return ( track is TrackData
      && this.name == track.name
      && this.artistName == track.artistName
      && this.albumName == track.albumName
    );
  }
}

class TrackTag
{
  String content = '';
  String name;

  TrackTag({
    @required this.content,
    this.name = '',
  });
}

class LetterData
{
  String letter = '';
  bool available = false;

  LetterData({
    @required this.letter,
    @required this.available,
  });
}