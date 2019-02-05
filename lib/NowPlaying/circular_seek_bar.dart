import 'package:flutter/material.dart';
import 'dart:math';

import 'package:restless/NowPlaying/now_playing_provider.dart';
import 'package:restless/NowPlaying/radial_drag_gesture_detector.dart';

class CircularSeekBar extends StatefulWidget {
  final double diameter;
  final Widget child;
  final double trackProgressPercent;
  final Function(double) onSeekRequested;

  const CircularSeekBar({
    Key key,
    @required this.onSeekRequested,
    @required this.trackProgressPercent,
    @required this.diameter,
    @required this.child,
  }) : super(key: key);

  @override
  CircularSeekBarState createState() {
    return CircularSeekBarState();
  }
}

class CircularSeekBarState extends State<CircularSeekBar> {

  double _thumbRadius = 2.0;
  bool _seeking = false;
  double percentComplete = 0.0;

  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent = 0.0;

  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    setState(() {
      _seeking = true;
      _thumbRadius *= 2;
    });
    _startDragPercent = (_startDragCoord.angle / (2*pi)) - (pi/4);
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() => _currentDragPercent = (_startDragPercent + dragPercent) % 1.0);
  }

  void _onDragEnd() {
    if(widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
      _thumbRadius /= 2;
      _seeking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_seeking);
    return Container(
      height: double.infinity,//MediaQuery.of(context).size.width,
      width: double.infinity,//MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: RadialDragGestureDetector(
        
        onRadialDragStart: _onDragStart,
        onRadialDragUpdate: _onDragUpdate,
        onRadialDragEnd: _onDragEnd,

        child: Center(
          child: Container(
            height: widget.diameter,
            width: widget.diameter,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  painter: CircularSeekBarPainter(
                    context: context,
                    radius: widget.diameter / 2,
                    percentComplete: _seeking?_currentDragPercent:(NowPlayingProvider.of(context).currentTime.inMilliseconds / NowPlayingProvider.of(context).endTime.inMilliseconds),
                    thumbRadius: _thumbRadius,
                    ),
                ),
                Center(
                  child: ClipOval(
                    child: Container(
                      width: widget.diameter * 0.9,
                      height: widget.diameter * 0.9,
                      color: Colors.transparent,
                      child: widget.child
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CircularSeekBarPainter extends CustomPainter
{
  BuildContext context;
  double percentComplete;
  double radius;
  double thumbRadius;

  CircularSeekBarPainter({
    @required this.context,
    @required this.radius,
    @required this.percentComplete,
    @required this.thumbRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double sweepAngle = ((percentComplete??0.0) * 2 * pi);
    Paint trackPaint = Paint()..style=PaintingStyle.stroke..color=Color.fromARGB(80, 80, 80, 80)..strokeWidth=3.0;
    Paint progressPaint = Paint()..style=PaintingStyle.stroke..color=Theme.of(context).primaryColor..strokeWidth=4.0..strokeCap=StrokeCap.round;
    Paint thumbPaint = Paint()..style=PaintingStyle.fill..color=Theme.of(context).primaryColor;

    canvas.translate(radius, radius);
    canvas.drawCircle(Offset.zero, radius, trackPaint);//paint track
    canvas.drawArc(//paint progress
      Rect.fromCircle(center: Offset.zero, radius: radius),
      -(pi/2),
      sweepAngle,
      false,
      progressPaint,
    );
    canvas.drawCircle(Offset((cos(sweepAngle-(pi/2)))*radius, (sin(sweepAngle-(pi/2)))*radius), thumbRadius, thumbPaint);//paint thumb
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

