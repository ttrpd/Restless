import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';

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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: PageView.builder(
        itemCount: widget.artist.albums.length,
        itemBuilder: (BuildContext context, int index) {
          return AlbumSongsPage(widget: widget, index: index,);
        },
      ),
    );
  }
}

class AlbumSongsPage extends StatelessWidget {
  const AlbumSongsPage({
    Key key,
    @required this.widget,
    @required this.index,
  }) : super(key: key);

  final int index;
  final AlbumPage widget;


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(//blurred background image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.artist.albums[index].albumArt ?? AssetImage('lib/assets/art8.jpg'),
              fit: BoxFit.fitHeight,
            )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 70.0, bottom: 50.0),
                  child: Container(
                    height: 30.0,
                    color: Theme.of(context).primaryColor,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        text: widget.artist.albums[index].name,
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
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                child: Container(
                  color: Colors.transparent,
                  height: widget.artist.albums[index].songs.length * 44.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.artist.albums[index].songs.length,
                    itemBuilder: (BuildContext context, int j) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 40.0,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                iconSize: 18,
                                icon: Icon(Icons.play_arrow, color: Theme.of(context).accentColor), 
                                onPressed: () {
                                  print(widget.artist.albums[index].songs[j].name + ' should be playing now');
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: widget.artist.albums[index].songs[j].name,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.0,
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: '0:00',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 1.0,
                                      height: 1.0
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}