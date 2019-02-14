import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/Artists/music_provider.dart';

import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/NowPlaying/Visualizer/visualizer.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class ArtistPage extends StatefulWidget
{
  final GetOffsetMethod getOffset;
  final SetOffsetMethod setOffset;
  final double sliverHeight;
  final Function() onArrowTap;
  final Function() onMenuTap;

  ArtistPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
    @required this.sliverHeight,
    @required this.onArrowTap,
    @required this.onMenuTap,
  }) : super(key: key);

  @override
  ArtistPageState createState() {
    return new ArtistPageState();
  }
}

class ArtistPageState extends State<ArtistPage> {

  ScrollController _scrl;
  double opacityValue = 0.0;

  @override
  void initState() {
    super.initState();
    _scrl = ScrollController(initialScrollOffset: widget.getOffset());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 30.0,
                          splashColor: Theme.of(context).primaryColorDark,
                          color: Theme.of(context).primaryColorDark,
                          onPressed: widget.onArrowTap,
                        ),
                        Expanded(child: Container(),),
                        IconButton(
                          icon: Icon(Icons.sort_by_alpha),
                          iconSize: 30.0,
                          splashColor: Theme.of(context).primaryColorDark,
                          color: Theme.of(context).primaryColorDark,
                          onPressed: widget.onMenuTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrl,
                  itemCount: MusicProvider.of(context).artists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSliver(context, index, _scrl.offset);
                  },
                ),
              ),
            ],
          ),
          AlphabetArtistPicker(
            opacityValue: opacityValue,
            scrolltoLetter: (l) {
              _scrl.jumpTo(
                MusicProvider.of(context).artists.indexOf(
                    MusicProvider.of(context).artists.where((a) => a.name.trim().toUpperCase()[0] == l).first
                ) * widget.sliverHeight
              );
              opacityValue = 0.0;
            },
          ),
        ],
      ),
    );
  }

  ArtistSliver _buildSliver(BuildContext context, int index, double offset) {
    String artist = MusicProvider.of(context).artists[index].name;
    if(!MusicProvider.of(context).artistSlivers.containsKey(artist))
    {
      ArtistSliver artistSliver = ArtistSliver(
        artist: MusicProvider.of(context).artists[index],
        height: widget.sliverHeight,
      );
      MusicProvider.of(context).artistSlivers.putIfAbsent(artist, ()=>artistSliver );
      return artistSliver;
    }
    else
    {
      return MusicProvider.of(context).artistSlivers[artist];
    }
  }
}


