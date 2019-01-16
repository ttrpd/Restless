

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
  String artistName;
  String albumName;
  ImageProvider albumArt;
  Set<TrackTag> tags = Set<TrackTag>();

  TrackData({
    @required this.path,
    this.name,
    this.tags,
    this.artistName,
    this.albumName,
    this.albumArt,
  });
}

class TrackTag
{
  String content;
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