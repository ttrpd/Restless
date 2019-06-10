import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:restless/MusicLibrary/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';


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
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: GestureDetector(
        onTapUp: (TapUpDetails t) {//navigate to album page
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
          width: MediaQuery.of(context).size.width,
          height: widget.height,
          child: Material(
            elevation: 20.0,
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Material(
                      elevation: 10.0,
                      color: Colors.transparent,
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
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    alignment: Alignment.centerLeft,
                    child: _buildArtistName(context)
                  ),
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
      padding: EdgeInsets.only(left: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  // background: Paint()..color = Theme.of(context).accentColor,
                  fontSize: 20.0,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.normal,
                  letterSpacing: 2.0,
                  height: 1.0
                ),
              ),
            ),
            RichText(
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: widget.artist.albums.length.toString()+' Album'+((widget.artist.albums.length>1)?'s':''),
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  // background: Paint()..color = Theme.of(context).accentColor,
                  fontSize: 16.0,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.0,
                  height: 1.0
                ),
              ),
            ),
          ],
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

