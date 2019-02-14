import 'package:flutter/material.dart';
import 'package:restless/Artists/music_provider.dart';
import 'package:restless/Albums/album_card.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class AlbumsPage extends StatefulWidget
{
  final GetOffsetMethod getOffset;
  final SetOffsetMethod setOffset;
  final Function() onArrowTap;
  final Function() onMenuTap;
  final double cardWidth;


  AlbumsPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
    @required this.cardWidth,
    @required this.onArrowTap,
    @required this.onMenuTap,
  }) : super(key: key);

  @override
  AlbumPageState createState() {
    return new AlbumPageState();
  }
}

class AlbumPageState extends State<AlbumsPage> {

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
      body: Column(
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
                      splashColor: Colors.grey,
                      color: Colors.grey,
                      onPressed: widget.onArrowTap,
                    ),
                    Expanded(child: Container(),),
                    IconButton(
                      icon: Icon(Icons.sort_by_alpha),
                      iconSize: 30.0,
                      splashColor: Colors.grey,
                      color: Colors.grey,
                      onPressed: widget.onMenuTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              controller: _scrl,
              itemCount: MusicProvider.of(context).getAlbums().length,
              itemBuilder: (BuildContext context, int index) {
                String album = MusicProvider.of(context).getAlbums()[index].name;
                AlbumCard albumSliver = AlbumCard(
                  album: MusicProvider.of(context).getAlbums()[index],
                  length: widget.cardWidth,
                );
                return albumSliver;
              },
            ),
          ),
        ],
      ),
    );
  }
}


