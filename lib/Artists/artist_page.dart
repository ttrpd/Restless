import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/Artists/artists_page_provider.dart';

import 'package:restless/Artists/artist_sliver.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class ArtistPage extends StatefulWidget
{
  GetOffsetMethod getOffset;
  SetOffsetMethod setOffset;


  ArtistPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
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
    print('artistPage');

    for(int i = 0; i < ArtistsPageProvider.of(context).artists.length ; i++)
    {
      ArtistsPageProvider.of(context).artists[i].albums.sort( (a, b) => a.name.compareTo(b.name));// sort albums
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha, color: Theme.of(context).accentColor,),
            onPressed: () {
              print(opacityValue);
              setState(() {
                opacityValue = (opacityValue > 0.0)?0.0:1.0;
              });
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: RichText(
          text: TextSpan(
            text: 'Artists',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 20.0,
            ),
          ),
        ),
        centerTitle: true,

      ),
      body: Stack(
        children: <Widget>[
          ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: Container(
              color: Theme.of(context).primaryColor,

              child: NotificationListener(
                child: ListView.builder(
                  controller: _scrl,
                  itemCount: ArtistsPageProvider.of(context).artists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ArtistSliver(
                      artist: ArtistsPageProvider.of(context).artists[index],
                    );
                  },
                ),
                onNotification: (notification) {
                  if(notification is ScrollNotification)
                    widget.setOffset(notification.metrics.pixels);
                },
              ),
            ),
          ),
          AlphabetArtistPicker(
            opacityValue: opacityValue,
            scrolltoLetter: (l) {
              _scrl.jumpTo(// *
                  ArtistsPageProvider.of(context).artists.indexOf(
                      ArtistsPageProvider.of(context).artists.where((a) => a.name.trim().toUpperCase()[0] == l).first
                  ) * ((MediaQuery.of(context).size.height / 4.75)+8.0)
              );
              opacityValue = 0.0;
            },
          ),
        ],
      ),
    );
  }
}


