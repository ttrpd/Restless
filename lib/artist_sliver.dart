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
    print(widget.artist + ' ' + widget.covers.toString());
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: 125.0,
            color: Colors.black,
            child: ListView.builder(
              itemCount: widget.covers.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                print((MediaQuery.of(context).size.width / ((widget.covers.length.toInt()>0 && widget.covers != null)?widget.covers.length:1)).toString());
                return Container(
                  width: MediaQuery.of(context).size.width / widget.covers.length.toInt(),
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.covers[index] ?? AssetImage('lib/assets/art8.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
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
}