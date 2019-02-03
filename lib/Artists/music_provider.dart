import 'package:flutter/material.dart';
import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/artist_data.dart';

class MusicProvider extends InheritedWidget
{
  List<ArtistData> artists;
  Map<String,ArtistSliver> artistSlivers;

  MusicProvider({
    Key key,
    Widget child,
    this.artists,
    this.artistSlivers,
  }) : super(key: key, child: child);

  List<AlbumData> getAlbums()
  {
    List<AlbumData> albums = List<AlbumData>();
    for(ArtistData artist in artists)
    {//unsorted at the moment
      albums.addAll(artist.albums);
    }
    return albums;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static MusicProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MusicProvider) as MusicProvider);
  }
}