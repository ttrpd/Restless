import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restless/HiddenDrawer/item_screen.dart';
import 'package:restless/HiddenDrawer/menu_item.dart';
import 'package:restless/NowPlaying/now_playing_page.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';



class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({
    Key key,
    this.maxSlidePercent = 0.8,
    @required this.artists,
    @required this.albums,
    // @required this.nowPlaying,
    @required this.playlists,
    @required this.settings,
    @required this.pgCtrl,
  }) : super(key: key);

  final double maxSlidePercent;
  final Widget artists;
  final Widget albums;
  // final Widget nowPlaying;
  final Widget playlists;
  final Widget settings;
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
  

  int selectedItem = 0;

  onItemScreenTap()
  {
    if(slidePercent == 1.0)
    {
      finishSlideStart = 1.0;
      finishSlideEnd = 0.0;
      finishSlideController.forward(from: 0.0);
    }
  }

  onArrowTap()
  {
    if(slidePercent == 0.0)
    {
      finishSlideStart = 0.0;
      finishSlideEnd = 1.0;
      finishSlideController.forward(from: 0.0);
    }
  }

  onMenuTap()
  {
    widget.pgCtrl.animateToPage(
      widget.pgCtrl.page==0?1:0,
      curve: Curves.ease,
      duration: Duration(milliseconds: 300)
    );
    print('yea');
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
                Color.fromARGB(255, 220, 220, 220),
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
              child: widget.artists,
              slidePercent: slidePercent,
              index: selectedItem - 0,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
            ),
            ItemScreen(
              child: widget.albums,
              slidePercent: slidePercent,
              index: selectedItem - 1,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
            ),
            (NowPlayingProvider.of(context).track != null)?ItemScreen(
              child: ClipRect(
                child: NowPlaying(
                  audioPlayer: NowPlayingProvider.of(context).audioPlayer,
                  pgCtrl: widget.pgCtrl,
                )
              ),
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
              appBarOpacity: 0,
            ):ItemScreen(
              child: Container(color: Colors.black,),
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
              appBarOpacity: 0,
            ),
            ItemScreen(
              child: widget.playlists,
              slidePercent: slidePercent,
              index: selectedItem - 3,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
            ),
            ItemScreen(
              child: widget.settings,
              slidePercent: slidePercent,
              index: selectedItem - 4,
              onArrowTap: onArrowTap,
              onMenuTap: onMenuTap,
              onItemScreenTap: onItemScreenTap,
            ),
          ],
        ),
      ],
    );
  }
}