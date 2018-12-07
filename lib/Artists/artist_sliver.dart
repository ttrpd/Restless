import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:restless/artist_data.dart';
import 'package:restless/AlbumPage/album_page.dart';


class ArtistSliver extends StatefulWidget
{
  ArtistData artist;

  ArtistSliver({
    Key key,
    @required this.artist,
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
      height: MediaQuery.of(context).size.height / 4.75,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 6.0, bottom: 6.0),
        child: GestureDetector(
          onTap: () {
            print(widget.artist);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AlbumPage(artist: widget.artist,),
              ),
            );
            print(widget.artist.name + ' was pressed');
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                // height: MediaQuery.of(context).size.height / 2.0,
                color: Theme.of(context).primaryColor,
                child: Stack(
                  children: _buildAlbumArtStack(context, MediaQuery.of(context).size.height),
                ),
              ),
              Container(

                child: Padding(
                  padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
                  child: RichText(
                    text: TextSpan(
                      text: widget.artist.name,
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
              ),
            ],
          ),
        ),
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
          width: MediaQuery.of(context).size.width,
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
        ClipPath(
          clipper: RhombusClipper(
              divideOffset: 100.0 / widget.artist.albums.length,
              slashPos: i * (MediaQuery.of(context).size.width / widget.artist.albums.length)
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
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