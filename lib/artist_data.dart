

import 'package:flutter/material.dart';

class ArtistData
{
  List<AlbumData> albums;

  ArtistData();
}

class AlbumData
{
  ImageProvider albumArt;
  List<TrackData> songs;

  AlbumData();
}

class TrackData
{
  String path;
  List<String> tags;

  TrackData();
}