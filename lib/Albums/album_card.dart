import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restless/Artists/music_provider.dart';

import 'package:restless/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';


class AlbumCard extends StatefulWidget
{
  final AlbumData album;
  final double length;

  AlbumCard({
    Key key,
    @required this.album,
    @required this.length,
  }) : super(key: key);

  @override
  AlbumCardState createState() {
    return AlbumCardState();
  }
}

class AlbumCardState extends State<AlbumCard> {
  double xOffset = 0.0;
  double yOffset = 0.0;
  
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTapDown: (TapDownDetails t) {
        setState(() {
          yOffset = ((MediaQuery.of(context).size.width / 2) - t.globalPosition.dx) / MediaQuery.of(context).size.width;
          xOffset = ((MediaQuery.of(context).size.height / 2) - t.globalPosition.dy) / MediaQuery.of(context).size.height;
        });
      },
      onTapCancel: () {
        setState(() {
          xOffset = 0.0;
          yOffset = 0.0; 
        });
      },
      onTapUp: (TapUpDetails t) {//navigate to album page
        setState(() {
          xOffset = 0.0;
          yOffset = 0.0;
        });
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            settings: RouteSettings(
              isInitialRoute: true,
            ),
            builder: (BuildContext context) => AlbumPage(artist: MusicProvider.of(context).artists.singleWhere((a)=>a.name==widget.album.songs.first.artistName),),
          ),
        );
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(xOffset)..rotateY(yOffset),
        child: Center(
          child: Stack(
            children: <Widget>[
              Center(
                child: Material(
                  elevation: 15.0,
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: widget.length * 0.9,
                      height: widget.length * 0.9,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/default.jpg'),
                        ),
                      ),
                      foregroundDecoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.album.albumArt,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: widget.length * 0.05, top: widget.length * 0.2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    width: widget.length * 0.7,
                    height: widget.length * 0.2,
                    child: _buildAlbumName(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildAlbumName(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RichText(
          maxLines: 1,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: widget.album.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 16.0,
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
      width: widget.length, //* 0.95,
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