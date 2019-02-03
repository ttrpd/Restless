import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/Artists/music_provider.dart';

import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class ArtistPage extends StatefulWidget
{
  final GetOffsetMethod getOffset;
  final SetOffsetMethod setOffset;
  final double sliverHeight;


  ArtistPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
    @required this.sliverHeight,
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
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: Container(
              color: Theme.of(context).accentColor,
              child: NotificationListener(
                onNotification: (notification) {//preserves the scroll position in list
                  if(notification is ScrollNotification)
                    widget.setOffset(notification.metrics.pixels);
                },
                child: ListView.builder(
                  controller: _scrl,
                  itemCount: MusicProvider.of(context).artists.length,
                  itemBuilder: (BuildContext context, int index) {
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
                  },
                ),
              ),
            ),
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
}


