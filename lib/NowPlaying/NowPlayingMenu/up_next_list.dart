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
  bool editing = false;
  @override
  Widget build(BuildContext context) {
    int itemCount = (NowPlayingProvider.of(context).playQueue==null)?0:NowPlayingProvider.of(context).playQueue.sublist(
                  NowPlayingProvider.of(context).getQueuePos()+1).length;
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
                        color: Theme.of(context).primaryColorDark,
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
                onPressed: ()=>setState((){editing = !editing;}),
                icon: Icon((editing)?Icons.cancel:Icons.edit),
                color: Theme.of(context).primaryColorDark,
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColorDark,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if(index == itemCount-1)
                return Container(
                  height: 200.0,
                  color: Colors.transparent,
                  alignment: Alignment.topCenter,
                  child: _buildSongSliver(index),
                );
              else
                return _buildSongSliver(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSongSliver(int index)
  {
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
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
                                color: Theme.of(context).primaryColorDark
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
                                color: Theme.of(context).primaryColorDark
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon((editing)?Icons.close:Icons.menu),
                      onPressed: (){
                        if(editing)
                          setState(() {
                            NowPlayingProvider.of(context).playQueue.removeAt(index+1); 
                          });
                        
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
