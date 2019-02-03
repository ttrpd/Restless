import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restless/Artists/music_provider.dart';

import 'package:restless/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';
import 'package:restless/diamond_frame.dart';


class AlbumSliver extends StatefulWidget
{
  final AlbumData album;
  final double height;

  AlbumSliver({
    Key key,
    @required this.album,
    @required this.height,
  }) : super(key: key);

  @override
  AlbumSliverState createState() {
    return AlbumSliverState();
  }
}

class AlbumSliverState extends State<AlbumSliver> {
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: () {//navigate to album page
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            settings: RouteSettings(
              isInitialRoute: true,
            ),
            builder: (BuildContext context) => AlbumPage(artist: MusicProvider.of(context).artists.singleWhere((a)=>a.name==widget.album.songs.first.artistName),),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: widget.height,
        width: MediaQuery.of(context).size.width * 0.95,
        color: Theme.of(context).accentColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 0.0, top: 3.0, bottom: 3.0),
              child: Row(
                children: <Widget>[
                  DiamondFrame(
                    height: widget.height * 0.8,
                    padding: 7.0,
                    child: _albums(context),
                  ),
                  Flexible(child: _buildAlbumName(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildAlbumName(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
        child: RichText(
          maxLines: 2,
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          text: TextSpan(
            text: widget.album.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              // background: Paint()..color = Theme.of(context).accentColor,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              height: 1.0
            ),
          ),
        ),
      ),
    );
  }

  Container _albums(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.height, //* 0.95,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/default.jpg'),
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.album.albumArt,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}