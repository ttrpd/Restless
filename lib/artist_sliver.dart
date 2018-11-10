import 'dart:math';

import 'package:flutter/material.dart';

class ArtistSliver extends StatefulWidget
{
  String artist;
  List<ImageProvider> covers;

  ArtistSliver({
    Key key,
    @required this.artist,
    @required this.covers,
  }) : super(key: key);

  @override
  ArtistSliverState createState() {
    return new ArtistSliverState();
  }
}

class ArtistSliverState extends State<ArtistSliver> {
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: 125.0,
            color: Colors.black,
            child: Stack(
              children: _buildAlbumArtStack(context),
            ),
          ),
          Container(
            
            child: Padding(
              padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
              child: RichText(
                text: TextSpan(
                  text: widget.artist,
                  style: TextStyle(
                    color: Colors.white,
                    background: Paint(),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    height: 1.0
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAlbumArtStack(BuildContext context)
  {
    List<Widget> artStack = List<Widget>();

    artStack.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.covers[0] ?? AssetImage('lib/assets/art8.jpg'),
                fit: BoxFit.cover,
              )
          ),
        )
    );

    for(int i = 1; i < widget.covers.length; i++)
    {
      artStack.add(
        ClipPath(
          clipper: RhombusClipper(divideOffset: 100.0 / widget.covers.length, slashPos: i * (MediaQuery.of(context).size.width / widget.covers.length) ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.covers[i] ?? AssetImage('lib/assets/art8.jpg'),
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
    // TODO: implement getClip
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