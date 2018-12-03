

import 'package:flutter/material.dart';

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
  ImageProvider albumArt;
  List<TrackData> songs;

  AlbumData({
    @required this.name,
    this.albumArt,
    this.songs,
  }){songs = new List<TrackData>();}
}

class TrackData
{
  String name;
  String path;
  Map<String, Object> tags = Map<String, Object>();

  TrackData({
    @required this.path,
    this.name,
    this.tags,
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