import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restless/Albums/albums_page.dart';
import 'package:restless/Artists/artist_page.dart';
import 'package:restless/HiddenDrawer/item_screen.dart';
import 'package:restless/HiddenDrawer/menu_item.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/Playlists/playlist_page.dart';



class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({
    Key key,
    this.maxSlidePercent = 0.8,
    @required this.sliverHeight,
    @required this.pgCtrl,
  }) : super(key: key);

  final double maxSlidePercent;
  // final Widget nowPlaying;

  final double sliverHeight;
  final PageController pgCtrl;


  @override
  HiddenDrawerState createState() {
    return new HiddenDrawerState();
  }
}

class HiddenDrawerState extends State<HiddenDrawer> with TickerProviderStateMixin{

  double slidePercent = 0.0;
  Offset startDrag;
  double startDragPercentSlide;
  double finishSlideStart;
  double finishSlideEnd;
  AnimationController finishSlideController;
  double artistsListOffset = 0.0;
  

  int selectedItem = 0;

  onItemScreenTap()
  {
    print("onItemScreenTap: " + slidePercent.toString());
    if(slidePercent == 1.0)
    {
      finishSlideStart = 1.0;
      finishSlideEnd = 0.0;
      finishSlideController.forward(from: 0.0);
    }
  }

  onArrowTap()
  {
    print("onArrowTap: " + slidePercent.toString());

    if(slidePercent == 0.0)
    {
      finishSlideStart = 0.0;
      finishSlideEnd = 1.0;
      finishSlideController.forward(from: 0.0);
    }
  }

  onMenuTap()
  {
    
  }


  @override
  void initState() {
    super.initState();

    finishSlideController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    )
    ..addListener(() {
      setState(() {
        slidePercent = lerpDouble(finishSlideStart, finishSlideEnd, finishSlideController.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Theme.of(context).dividerColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MenuItem(
                    text: 'Artists',
                    onPressed: (){
                      setState(() {
                        selectedItem = 0;
                      });
                      onItemScreenTap();
                    },
                    selected: (selectedItem == 0)?true:false,
                    enabled: true,
                  ),
                  MenuItem(
                    text: 'Albums',
                    onPressed: (){
                      setState(() {
                        selectedItem = 1;                        
                      });
                      onItemScreenTap();
                    },
                    selected: (selectedItem == 1)?true:false,
                    enabled: true,
                  ),
                  MenuItem(
                    text: 'Nowplaying',
                    onPressed: (){
                      setState(() {
                        selectedItem = 2;                        
                      });
                      onItemScreenTap();
                    },
                    selected: (selectedItem == 2)?true:false,
                    enabled: (NowPlayingProvider.of(context).track != null)?true:false,
                  ),
                  MenuItem(
                    text: 'Playlists',
                    onPressed: (){
                      setState(() {
                        selectedItem = 3;                        
                      });
                      onItemScreenTap();
                    },
                    selected: (selectedItem == 3)?true:false,
                    enabled: true,
                  ),
                  MenuItem(
                    text: 'Settings',
                    onPressed: (){
                      setState(() {
                        selectedItem = 4;                        
                      });
                      onItemScreenTap();
                    },
                    selected: (selectedItem == 4)?true:false,
                    enabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            ItemScreen(
              child: ArtistPage(
                getOffset: () => artistsListOffset,
                setOffset: (offset) => artistsListOffset = offset,
                sliverHeight: widget.sliverHeight,
                onArrowTap: onArrowTap,
                onMenuTap: onMenuTap,
              ),
              slidePercent: slidePercent,
              index: selectedItem - 0,
              onItemScreenTap: onItemScreenTap,
            ),
            ItemScreen(
              child: AlbumsPage(
                getOffset: () => artistsListOffset,
                setOffset: (offset) => artistsListOffset = offset,
                cardWidth: MediaQuery.of(context).size.width * 0.45,
                onArrowTap: onArrowTap,
                onMenuTap: onMenuTap,
              ),
              slidePercent: slidePercent,
              index: selectedItem - 1,
              onItemScreenTap: onItemScreenTap,
            ),
            (NowPlayingProvider.of(context).track != null)?ItemScreen(
              child: ClipRect(
                child: NowPlaying(
                  audioPlayer: NowPlayingProvider.of(context).audioPlayer,
                  pgCtrl: widget.pgCtrl,
                  onArrowTap: onArrowTap,
                  onMenuTap: () {//onMenuTap
                    widget.pgCtrl.animateToPage(
                      widget.pgCtrl.page==0?1:0,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 300)
                    );
                  },
                )
              ),
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onItemScreenTap: onItemScreenTap,
              appBarOpacity: 0,
            ):ItemScreen(
              child: Container(color: Colors.black,),
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onItemScreenTap: onItemScreenTap,
              appBarOpacity: 0,
            ),
            ItemScreen(
              child: PlaylistPage(
                sliverHeight: widget.sliverHeight,
                onArrowTap: onArrowTap,
                onMenuTap: (){},
              ),
              slidePercent: slidePercent,
              index: selectedItem - 3,
              onItemScreenTap: onItemScreenTap,
            ),
            ItemScreen(
              child: Container(color: Colors.tealAccent,),
              slidePercent: slidePercent,
              index: selectedItem - 4,
              onItemScreenTap: onItemScreenTap,
            ),
          ],
        ),
      ],
    );
  }
}