import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restless/music_provider.dart';

import 'package:restless/MusicLibrary/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';


class AlbumCard extends StatefulWidget
{
  final AlbumData album;
  final double height;
  final double width;

  AlbumCard({
    Key key,
    @required this.album,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  @override
  AlbumCardState createState() {
    return AlbumCardState();
  }
}

class AlbumCardState extends State<AlbumCard> {
  
  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: GestureDetector(
        onTapUp: (TapUpDetails t) {//navigate to album page
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute<void>(
              settings: RouteSettings(
                isInitialRoute: true,
              ),
              builder: (BuildContext context) => AlbumPage(artist: MusicProvider.of(context).artists.singleWhere((a)=>a.name==widget.album.songs.first.artistName),),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
              child: Container(
                width: widget.width,
                  height: widget.width,
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
            _buildAlbumName(context)

          ],
        ),
        // child: Column(
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Material(
        //         elevation: 15.0,
        //         color: Colors.transparent,
        //         child: Container(
        //           width: widget.width,
        //           height: widget.height,
        //           decoration: BoxDecoration(
        //             image: DecorationImage(
        //               image: AssetImage('lib/assets/default.jpg'),
        //             ),
        //           ),
        //           foregroundDecoration: BoxDecoration(
        //             image: DecorationImage(
        //               image: widget.album.albumArt,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     // Container(
        //     //   color: Theme.of(context).primaryColor,
        //     //   child: _buildAlbumName(context),
        //     // ),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildAlbumName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: widget.album.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 14.0,
                letterSpacing: 1.0,
                height: 0.75
              ),
            ),
          ),
          RichText(
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: widget.album.songs.first.artistName.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 10.0,
                letterSpacing: 1.0,
                height: 1.0
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _albums(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.width,
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