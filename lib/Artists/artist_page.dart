import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/Artists/artists_page_provider.dart';

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
      
      body: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: NotificationListener(
                onNotification: (notification) {//preserves the scroll position in list
                  if(notification is ScrollNotification)
                    widget.setOffset(notification.metrics.pixels);
                },
                child: ListView.builder(
                  controller: _scrl,
                  itemCount: ArtistsPageProvider.of(context).artists.length,
                  itemBuilder: (BuildContext context, int index) {
                    String artist = ArtistsPageProvider.of(context).artists[index].name;
                    if(!ArtistsPageProvider.of(context).artistSlivers.containsKey(artist))
                    {
                      ArtistSliver artistSliver = ArtistSliver(
                        artist: ArtistsPageProvider.of(context).artists[index],
                        height: widget.sliverHeight,
                      );
                      ArtistsPageProvider.of(context).artistSlivers.putIfAbsent(artist, ()=>artistSliver );
                      return artistSliver;
                    }
                    else
                    {
                      return ArtistsPageProvider.of(context).artistSlivers[artist];
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
                ArtistsPageProvider.of(context).artists.indexOf(
                    ArtistsPageProvider.of(context).artists.where((a) => a.name.trim().toUpperCase()[0] == l).first
                ) * widget.sliverHeight
              );
              opacityValue = 0.0;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 24.0),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.sort_by_alpha),
              onPressed: () {
                print(opacityValue);
                setState(() {
                  opacityValue = (opacityValue > 0.0)?0.0:1.0;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


