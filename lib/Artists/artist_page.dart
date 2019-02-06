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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.sort_by_alpha),
        onPressed: () {
          print(opacityValue);
          setState(() {
            opacityValue = (opacityValue > 0.0)?0.0:1.0;
          });
        },
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 30.0,
                          splashColor: Colors.grey,
                          color: Colors.grey,
                          onPressed: widget.onArrowTap,
                        ),
                        Expanded(child: Container(),),
                        IconButton(
                          icon: Icon(Icons.menu),
                          iconSize: 30.0,
                          splashColor: Colors.grey,
                          color: Colors.grey,
                          onPressed: widget.onMenuTap,
                        ),
                      ],
                    ),
                  ),
                ),                
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.85,
                      color: Theme.of(context).primaryColor,
                      child: ScrollConfiguration(
                        behavior: MyScrollBehavior(),
                        child: NotificationListener(
                          onNotification: (notification) {//preserves the scroll position in list
                            if(notification is ScrollNotification)
                              widget.setOffset(notification.metrics.pixels);
                          },
                          child: ListView.builder(
                            controller: _scrl,
                            itemCount: MusicProvider.of(context).artists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  _buildSliver(context, index),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                    child: Divider(
                                      height: 1.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //column: expanded, visualizer
            Column(
              children: <Widget>[
                Expanded(child: Container(),),
                Visualizer(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  currentTime: NowPlayingProvider.of(context).currentTime.inMilliseconds.toDouble(),
                  endTime: NowPlayingProvider.of(context).endTime.inMilliseconds.toDouble(),
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  height: 40.0,
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
      ),
    );
  }

  ArtistSliver _buildSliver(BuildContext context, int index) {
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


