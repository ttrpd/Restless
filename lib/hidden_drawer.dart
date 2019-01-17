import 'package:flutter/material.dart';


class ZoomDrawer extends StatefulWidget {
  const ZoomDrawer({
    Key key,
    @required this.child,
    this.maxSlidePercent = 0.8,
  }) : super(key: key);

  final Widget child;
  final double maxSlidePercent;

  @override
  ZoomDrawerState createState() {
    return new ZoomDrawerState();
  }
}

class ZoomDrawerState extends State<ZoomDrawer> {

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
    final fullSlidePercent = slideDistance / widget.maxSlidePercent;

    setState(() {
      slidePercent = (startDragPercentSlide + fullSlidePercent).clamp(0.0, widget.maxSlidePercent);//clamping just in case   
    });
  }

  horizontalDragEnd(DragEndDetails details)
  {
    setState(() {
      startDrag = null;
      startDragPercentSlide = null;      
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
          color: Color.fromARGB(255, 50, 50, 50),
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
          transform: Matrix4.translationValues( (MediaQuery.of(context).size.width * 0.9) * slidePercent , 0.0, 0.0)..scale(1-(0.2 * slidePercent)),
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