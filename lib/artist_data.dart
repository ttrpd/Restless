

import 'package:flutter/material.dart';

class ArtistData
{
  String name;
  List<AlbumData> albums = List<AlbumData>(1);

  ArtistData({
    @required this.name,
    this.albums,
  });
}

class AlbumData
{
  String name;
  ImageProvider albumArt;
  List<TrackData> songs = List<TrackData>(1);

  AlbumData({
    @required this.name,
    this.albumArt,
    this.songs,
  });
}

class TrackData
{
  String name;
  String path;
  List<String> tags = List<String>(1);

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