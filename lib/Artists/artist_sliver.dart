import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:restless/artist_data.dart';
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
    return new ArtistSliverState();
  }
}

class ArtistSliverState extends State<ArtistSliver> {
  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 3.0, bottom: 3.0),
        child: GestureDetector(
          onTap: () {//navigate to album page
            print(widget.artist);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AlbumPage(artist: widget.artist,),
              ),
            );
          },
          child: Stack(
            children: <Widget>[
              _albums(context),
              // Container(
              //   alignment: Alignment.bottomLeft,
              //   width: MediaQuery.of(context).size.width * 0.95,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.bottomCenter,
              //       end: Alignment.topCenter,
              //       colors: [const Color.fromARGB(120, 0, 0, 0), Colors.transparent],
              //       tileMode: TileMode.repeated,
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
              //     child: RichText(
              //       text: TextSpan(
              //         text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
              //         style: TextStyle(
              //           fontFamily: 'sans serif',
              //           fontStyle: ,
              //           color: Theme.of(context).accentColor,
              //           fontSize: 24.0,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              _buildArtistName(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildArtistName(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
        child: RichText(
          text: TextSpan(
            text: widget.artist.name.replaceAll('"', '/').replaceAll('∕', '/').replaceAll('"', ''),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              background: Paint()..color = Theme.of(context).primaryColor,
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
        children: _buildAlbumArtStack(context, MediaQuery.of(context).size.height),
      ),
    );
  }

  List<Widget> _buildAlbumArtStack(BuildContext context, double height)
  {
    double width = MediaQuery.of(context).size.width;// * 0.95;

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