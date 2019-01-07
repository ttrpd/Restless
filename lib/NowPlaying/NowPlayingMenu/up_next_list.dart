import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class UpNextList extends StatefulWidget {
  const UpNextList({
    Key key,
  }) : super(key: key);

  @override
  UpNextListState createState() {
    return new UpNextListState();
  }
}

class UpNextListState extends State<UpNextList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  child: RichText(
                    text: TextSpan(
                      text: 'Up Next',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: (){},
                ),

              ),
              Expanded(child: Container(),),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.clear),
                color: Theme.of(context).accentColor,
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.add),
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
        Container(
          height: 280.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: (NowPlayingProvider.of(context).playQueue==null)?0:NowPlayingProvider.of(context).playQueue.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Divider(
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: double.maxFinite,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          children: <Widget>[
                            RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].tags['track'],
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0,
                                  height: 1.0,
                                  letterSpacing: 0.0,
                                  color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: RichText(
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor
                                  ),
                                ),
                              ),
                            ),
                            RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[index].artistName,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                            Expanded(child: Container(),),
                            RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                text: '0:00',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  height: 1.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
