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
          padding: const EdgeInsets.only(top: 2.0),
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
                        color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: (NowPlayingProvider.of(context).playQueue==null)?0:NowPlayingProvider.of(context).playQueue.sublist(
                NowPlayingProvider.of(context).getQueuePos()+1
              ).length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Color.fromARGB(200, 255, 255, 255),
                onTap: (){
                  NowPlayingProvider.of(context).track = NowPlayingProvider.of(context).playQueue.elementAt(NowPlayingProvider.of(context).getQueuePos()+index+1);
                  setState(() {
                    NowPlayingProvider.of(context).playCurrentTrack();                    
                  });
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40.0,
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            children: <Widget>[
                              Container(
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
                                          color: Theme.of(context).primaryColor
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
                                          color: Theme.of(context).primaryColor
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    color: Theme.of(context).primaryColor
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
