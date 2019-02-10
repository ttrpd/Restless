import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:restless/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';
import 'package:restless/diamond_frame.dart';


class ArtistSliver extends StatefulWidget
{
  final ArtistData artist;
  final double height;

  ArtistSliver({
    Key key,
    @required this.artist,
    @required this.height,
  }) : super(key: key);

  @override
  ArtistSliverState createState() {
    return ArtistSliverState();
  }
}

class ArtistSliverState extends State<ArtistSliver> {
  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      splashColor: Colors.white70,
      child: GestureDetector(
        onTap: () {//navigate to album page
          print(widget.artist);
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute<void>(
              settings: RouteSettings(
                isInitialRoute: true,
              ),
              builder: (BuildContext context) => AlbumPage( artist: widget.artist,),
            ),
          );
        },
        child: Container(
          height: widget.height,
          width: double.infinity,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Stack(
              children: <Widget>[
                // Container(
                //   foregroundDecoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         Theme.of(context).primaryColor,
                //         Colors.transparent,
                //       ],
                //       stops: [
                //         0.3,
                //         1.0,
                //       ],
                //     ),
                //   ),
                //   child: _albums(context),
                // ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: _buildArtistName(context)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtistName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.height * 0.15, left: 10.0),
      child: Container(
        child: RichText(
          maxLines: 1,
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          text: TextSpan(
            text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              // background: Paint()..color = Theme.of(context).accentColor,
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
      width: MediaQuery.of(context).size.width, //* 0.95,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/default.jpg'),
        )
      ),
      foregroundDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(200)
      ),
      child: Stack(
        children: _buildAlbumArtStack(context, MediaQuery.of(context).size.width * 0.8),
      ),
    );
  }

  List<Widget> _buildAlbumArtStack(BuildContext context, double height)
  {

    List<Widget> artStack = List<Widget>();
    if(widget.artist.albums == null)
      print(widget.artist.name + ' has no albums');

    artStack.add(
      Container(
        width: height,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.artist.albums[0].albumArt ?? AssetImage('lib/assets/default.jpg'),
            fit: BoxFit.cover,
          )
        ),
      )
    );

    for(int i = 1; i < widget.artist.albums.length; i++)
    {
      artStack.add(
        ClipPath(//Clipped Art
          clipper: RhombusClipper(
              divideOffset: 100.0 / widget.artist.albums.length,
              slashPos: i * (height / widget.artist.albums.length)
          ),
          child: Container(
            width: height,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.artist.albums[i].albumArt ?? AssetImage('lib/assets/art8.jpg'),
                fit: BoxFit.cover,
              )
            ),
          ),
        )
      );
    }
    return artStack;
  }
}



class RhombusClipper extends CustomClipper<Path>
{
  double divideOffset;
  double slashPos;

  RhombusClipper({
    Key key,
    @required this.divideOffset,
    @required this.slashPos,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(slashPos + divideOffset, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(slashPos - divideOffset, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}

