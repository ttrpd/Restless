import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';

class ArtistsPageProvider extends InheritedWidget
{
  List<ArtistData> artists;

  ArtistsPageProvider({
    Key key,
    Widget child,
    this.artists,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static ArtistsPageProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ArtistsPageProvider) as ArtistsPageProvider);
  }
}