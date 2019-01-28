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
    return GestureDetector(
      onTap: () {//navigate to album page
        print(widget.artist);
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            builder: (BuildContext context) => AlbumPage(artist: widget.artist,),
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
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 3.0, bottom: 3.0),
              child: Row(
                children: <Widget>[
                  DiamondFrame(
                    height: widget.height * 0.8,
                    padding: 7.0,
                    child: _albums(context),
                  ),
                  Flexible(child: _buildArtistName(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildArtistName(BuildContext context) {
    return Container(
      constraints: BoxConstraints(

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
        child: RichText(
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
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
      width: MediaQuery.of(context).size.width, //* 0.95,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('lib/assets/default.jpg'),
        )
      ),
      child: Stack(
        children: _buildAlbumArtStack(context, widget.height * 0.8),
      ),
    );
  }

  List<Widget> _buildAlbumArtStack(BuildContext context, double height)
  {
    double width = height;// * 0.95;

    List<Widget> artStack = List<Widget>();
    if(widget.artist.albums == null)
      print(widget.artist.name + ' has no albums');

    artStack.add(
      Container(
        alignment: Alignment.center,
        width: width,
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
              slashPos: i * (width / widget.artist.albums.length)
          ),
          child: Container(
            width: width,
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

