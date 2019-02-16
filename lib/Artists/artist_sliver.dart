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

  double xOffset = 0.0;
  double yOffset = 0.0;

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: GestureDetector(
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
              builder: (BuildContext context) => AlbumPage( artist: widget.artist,),
            ),
          );
        },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(xOffset)..rotateY(yOffset),
          child: Stack(
            children: <Widget>[
              Material(
                elevation: 20.0,
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: widget.height,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: _buildArtistName(context)
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Transform(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    child: Material(
                      elevation: 10.0,
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Material(
                          elevation: 10.0,
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            child: _albums(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtistName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.5,
        child: RichText(
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              // background: Paint()..color = Theme.of(context).accentColor,
              fontSize: 30.0,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.normal,
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
      width: 100.0, //* 0.95,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/default.jpg'),
        )
      ),
      child: Stack(
        children: _buildAlbumArtStack(context, 100.0),
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

