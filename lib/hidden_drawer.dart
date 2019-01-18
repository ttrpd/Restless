import 'dart:ui';

import 'package:flutter/material.dart';


class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({
    Key key,
    @required this.child,
    this.maxSlidePercent = 0.8,
  }) : super(key: key);

  final Widget child;
  final double maxSlidePercent;

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
      slidePercent = (startDragPercentSlide + fullSlidePercent).clamp(0.0, widget.maxSlidePercent);//clamping just in case   
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
          // color: Color.fromARGB(255, 50, 50, 50),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,

              colors: [
                Color.fromARGB(255, 30, 30, 30),
                Color.fromARGB(255, 80, 80, 80),
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
                  menuItem(context, 'Collections'),
                  menuItem(context, 'Artists'),
                  menuItem(context, 'Albums'),
                  menuItem(context, 'NowPlaying'),
                  menuItem(context, 'Settings'),                    
                ],
              ),
            ),
          ),
        ),
        Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.translationValues( (MediaQuery.of(context).size.width * 0.8) * slidePercent , 0.0, 0.0)..scale(1-(0.3 * slidePercent)),
          child: GestureDetector(
            onHorizontalDragStart: horizontalDragStart,
            onHorizontalDragUpdate: horizontalDragUpdate,
            onHorizontalDragEnd: horizontalDragEnd,
            behavior: HitTestBehavior.translucent,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(68, 0, 0, 0),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 20.0,
                    spreadRadius: 10.0,
                  ),
                ],
              ),
              child: widget.child
            ),
          ),
        ),
      ],
    );
  }

  Widget menuItem(BuildContext context, String text)
  {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: FlatButton(
        onPressed: (){print('pressed!');},
        child: RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}