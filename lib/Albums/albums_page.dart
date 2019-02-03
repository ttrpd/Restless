import 'package:flutter/material.dart';
import 'package:restless/Artists/music_provider.dart';
import 'package:restless/Albums/album_sliver.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class AlbumsPage extends StatefulWidget
{
  final GetOffsetMethod getOffset;
  final SetOffsetMethod setOffset;
  final double sliverHeight;


  AlbumsPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
    @required this.sliverHeight,
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
      body: ScrollConfiguration(
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
              itemCount: MusicProvider.of(context).getAlbums().length,
              itemBuilder: (BuildContext context, int index) {
                String album = MusicProvider.of(context).getAlbums()[index].name;
                AlbumSliver albumSliver = AlbumSliver(
                  album: MusicProvider.of(context).getAlbums()[index],
                  height: widget.sliverHeight,
                );
                return albumSliver;
              },
            ),
          ),
        ),
      ),
    );
  }
}


