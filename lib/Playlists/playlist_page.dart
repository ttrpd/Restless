import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/music_provider.dart';

import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class PlaylistPage extends StatefulWidget
{
  final double sliverHeight;
  final Function() onArrowTap;
  final Function() onMenuTap;

  PlaylistPage({
    Key key,
    @required this.sliverHeight,
    @required this.onArrowTap,
    @required this.onMenuTap,
  }) : super(key: key);

  @override
  PlaylistPageState createState() {
    return PlaylistPageState();
  }
}

class PlaylistPageState extends State<PlaylistPage> {

  ScrollController _scrl;
  double opacityValue = 0.0;

  @override
  void initState() {
    super.initState();
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
                          onPressed: (){
                            setState(() {
                              opacityValue = (opacityValue - 1.0).abs();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrl,
                  itemCount: MusicProvider.of(context).artists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(color: Colors.transparent, height: 100.0,);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}