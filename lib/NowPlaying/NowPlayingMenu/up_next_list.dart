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
                        color: (NowPlayingProvider.of(context).playQueue.length<1)?Colors.red:Theme.of(context).accentColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: (){},
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.edit),
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).accentColor,
        ),
        Container(
          height: 258.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: (NowPlayingProvider.of(context).playQueue==null)?0:NowPlayingProvider.of(context).playQueue.sublist(
                NowPlayingProvider.of(context).getQueuePos()+1
              ).length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Color.fromARGB(10, 255, 255, 255),
                onTap: (){},
                child: Column(
                  children: <Widget>[
                    // Divider(
                    //   color: Theme.of(context).accentColor,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40.0,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[NowPlayingProvider.of(context).getQueuePos()+index+1].name,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            height: 1.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).accentColor
                                          ),
                                        ),
                                      ),    
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: (NowPlayingProvider.of(context).playQueue==null)?'':NowPlayingProvider.of(context).playQueue[NowPlayingProvider.of(context).getQueuePos()+index+1].artistName,
                                          style: TextStyle(
                                            fontSize: 14.0,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
