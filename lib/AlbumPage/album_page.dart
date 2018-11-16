import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AlbumPage extends StatefulWidget {

  ArtistData artist;

  AlbumPage({
    Key key,
    @required this.artist,
  }) : super(key: key);


  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            //TODO: navigate back to artistPage
            Navigator.of(context).pop();
          },
        ),
        title: RichText(
          text: TextSpan(
            text: widget.artist.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.artist.albums.length,
        itemBuilder: (BuildContext context, int index) {
          return StickyHeader(
            header: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.artist.albums[index].albumArt ?? AssetImage('lib/assets/default.jpg'),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 4.75,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    text: TextSpan(
                      text: widget.artist.albums[index].name,
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
              ],
            ),
            content: Container(
              height: 200.0,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.artist.albums.length,
                itemBuilder: (BuildContext context, int j) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(color: Colors.lightBlue, height: 50.0,),
                  );
                },
              ),
            ),
          );
        },
      ),
      // body: ListView.builder(
      //   itemCount: widget.artist.albums.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     print(widget.artist.albums[index].name);
      //     return StickyHeader(
      //       header: Padding(
      //         padding: const EdgeInsets.only(top: 8.0),
      //         child: Stack(
      //           children: <Widget>[
      //             Container(
      //               width: double.maxFinite,
      //               height: MediaQuery.of(context).size.height / 4.75,
      //               color: Colors.black,
      //               decoration: BoxDecoration(
      //                 image: DecorationImage(
      //                   image: widget.artist.albums[index].albumArt ?? AssetImage('lib/assets/default.jpg'),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ),
      //             Container(

      //               child: Padding(
      //                 padding: const EdgeInsets.only(top: 12.5, left: 10.0, right: 5.0, bottom: 5.0),
      //                 child: RichText(
      //                   text: TextSpan(
      //                     text: widget.artist.name,
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       background: Paint(),
      //                       fontSize: 26.0,
      //                       fontWeight: FontWeight.bold,
      //                       letterSpacing: 2.0,
      //                       height: 1.0
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ), content: Container(color: Colors.amberAccent, height: 400.0,),
      //     );
      //   },
      // ),
    );
  }
}