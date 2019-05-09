import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/artist_data.dart';

class MusicProvider extends InheritedWidget
{
  StreamController<TrackData> artistStreamCtrl = new StreamController<TrackData>.broadcast();
  List<ArtistData> artists = new List<ArtistData>();
  Map<String,ArtistSliver> artistSlivers;
  String _musicDirectoryPath = '/storage/emulated/0/Music';//'/storage/emulated/0/Music/TestMusic';
  

  MusicProvider({
    Key key,
    Widget child,
    this.artists,
    this.artistSlivers,
  }) : super(key: key, child: child)
  {
    artistStreamCtrl.stream.listen((data)=>data);
    _getMusicData(_musicDirectoryPath);
  }

  List<AlbumData> getAlbums()
  {
    List<AlbumData> albums = List<AlbumData>();
    for(ArtistData artist in artists)
    {//unsorted at the moment
      albums.addAll(artist.albums);
    }
    return albums;
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
            artistName: (img.last.tags['TPE2']??'Unknown Artist').trim(),
            albumName: (img.last.tags['album']??'Unknown Album').trim(),
            albumArt: albumArt
          );
          AlbumData album = AlbumData(name: track.albumName, albumArt: albumArt, songs: [track],);
          ArtistData artist = ArtistData(name: track.artistName, albums: [album],);
          print(artist.name);// + " - " + album.name + " - " + name + " - " + img.toString());

          // add artist to list of artists
          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.add(artist);
          }
          
          // find artist and add to their albums
          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.add(album);
          }

          // find album and add to its songs
          if(artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse: ()=>null)
            .songs.firstWhere( (s) => s.name.toUpperCase().trim() == track.name.toUpperCase().trim(), orElse: ()=>null) == null)
          {
            artists.firstWhere( (a) => a.name.toUpperCase().trim() == track.artistName.toUpperCase().trim(), orElse: ()=>null)
            .albums.firstWhere( (al) => al.name.toUpperCase().trim() == track.albumName.toUpperCase().trim(), orElse:()=>null)
            .songs.add(track);
          }

          artistStreamCtrl.sink.add(track);
        }
      }
    }
  }

  Set<TrackTag> extractBasicTags(Map<String, dynamic> tags, String trackName)
  {
    Set<TrackTag> tagOutput = Set<TrackTag>();
    tagOutput.add(TrackTag(name: 'name', content: trackName));
    tagOutput.add(TrackTag(name: 'artist', content: (tags['TPE2']??'Unknown Artist').trim()));
    tagOutput.add(TrackTag(name: 'album', content: (tags['album']??'Unknown Album').trim()));
    tagOutput.add(TrackTag(name: 'number', content: (tags['track']??'0').trim()));
    return tagOutput;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static MusicProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MusicProvider) as MusicProvider);
  }
}