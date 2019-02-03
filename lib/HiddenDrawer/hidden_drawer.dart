import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restless/HiddenDrawer/item_screen.dart';
import 'package:restless/HiddenDrawer/menu_item.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';



class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({
    Key key,
    this.maxSlidePercent = 0.8,
    @required this.artists,
    @required this.albums,
    @required this.nowPlaying,
    @required this.playlists,
    @required this.settings,
  }) : super(key: key);

  final double maxSlidePercent;
  final Widget artists;
  final Widget albums;
  final Widget nowPlaying;
  final Widget playlists;
  final Widget settings;

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

  horizontalDragStart(DragStartDetails details)
  {
    startDrag = details.globalPosition;
    startDragPercentSlide = slidePercent;
  }

  horizontalDragUpdate(DragUpdateDetails details)
  {
    final currentSlide = details.globalPosition;
    final slideDistance = currentSlide.dx - startDrag.dx;
    final fullSlidePercent = slideDistance / (widget.maxSlidePercent * MediaQuery.of(context).size.width);

    setState(() {
      slidePercent = (startDragPercentSlide + fullSlidePercent).clamp(0.0, widget.maxSlidePercent);   
    });
  }

  horizontalDragEnd(DragEndDetails details)
  {
    finishSlideStart = slidePercent;
    finishSlideEnd = slidePercent.roundToDouble() * (widget.maxSlidePercent);
    finishSlideController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentSlide = null;      
    });
  }

  onTap()
  {
    finishSlideStart = slidePercent;
    finishSlideEnd = 0.0;
    finishSlideController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentSlide = null;      
    });
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
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 0,
              onTap: onTap,
            ),
            ItemScreen(
              child: widget.albums,
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 1,
              onTap: onTap,
            ),
            (NowPlayingProvider.of(context).track != null)?ItemScreen(
              child: widget.nowPlaying,
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onTap: onTap,
            ):ItemScreen(
              child: Container(color: Colors.black,),
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 2,
              onTap: onTap,
            ),
            ItemScreen(
              child: widget.playlists,
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 3,
              onTap: onTap,
            ),
            ItemScreen(
              child: widget.settings,
              dragStart: horizontalDragStart,
              dragUpdate: horizontalDragUpdate,
              dragEnd: horizontalDragEnd,
              slidePercent: slidePercent,
              index: selectedItem - 4,
              onTap: onTap,
            ),
          ],
          // children: this.itemScreensList,
        ),

      ],
    );
  }
}