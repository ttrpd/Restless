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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: RichText(
          text: TextSpan(
            text: widget.artist.name,
            style: TextStyle(
              color: Theme.of(context).accentColor,
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
                        color: Theme.of(context).accentColor,
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
              height: (index != widget.artist.albums.length-1)?58.0 * widget.artist.albums.length:(MediaQuery.of(context).size.height*0.66),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.artist.albums[index].songs.length,
                itemBuilder: (BuildContext context, int j) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50.0,
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.play_arrow, color: Theme.of(context).accentColor), 
                              onPressed: () {
                                print(widget.artist.albums[index].songs[j].name + ' should be playing now');
                              },
                            ),
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: widget.artist.albums[index].songs[j].name,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    height: 1.0
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}