

import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget
{

  double trackThickness;
  Color trackColor;
  double progressThickness;
  Color progressColor;
  double progressPercent;
  double thumbHeight;
  double thumbWidth;
  Color thumbColor;

  SeekBar({
    Key key,
    this.trackThickness = 2.0,
    this.trackColor = Colors.white30,
    this.progressThickness = 2.0,
    this.progressColor = Colors.white,
    this.progressPercent = 0.3,
    this.thumbHeight = -10.0,
    this.thumbWidth = 3.0,
    this.thumbColor = Colors.white
  }) : super(key: key);

  @override
  SeekBarState createState() {
    return new SeekBarState();
  }
}

class SeekBarState extends State<SeekBar> {
  @override
  Widget build(BuildContext context)
  {
    return CustomPaint(
      painter: SeekBarPainter(
        trackThickness: widget.trackThickness,
        trackColor: widget.trackColor,
        progressThickness: widget.progressThickness,
        progressColor: widget.progressColor,
        progressPercent: widget.progressPercent,
        thumbHeight: widget.thumbHeight,
        thumbWidth: widget.thumbWidth,
        thumbColor: widget.thumbColor
      ),
    );
  }
}

class SeekBarPainter extends CustomPainter
{

  double trackThickness;
  Paint trackPaint;
  double progressThickness;
  double progressPercent;
  Paint progressPaint;
  double thumbHeight;
  double thumbWidth;
  Paint thumbPaint;

  SeekBarPainter({
    @required this.trackThickness,
    @required trackColor,
    @required this.progressThickness,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbHeight,
    @required this.thumbWidth,
    @required thumbColor,
  }) : trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke // maybe fill
        ..strokeWidth = trackThickness , // dependent on trackPaint.style
       progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke // dependent on trackPaint.style
        ..strokeWidth = progressThickness
        ..strokeCap = StrokeCap.square ,
       thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint track
    canvas.drawRect(
      Rect.fromLTWH(0.0, progressThickness, size.width, size.height),
      trackPaint
    );

    // Paint progress
    canvas.drawRect(
      Rect.fromLTWH(0.0, size.height, size.width * progressPercent, progressThickness),
      progressPaint
    );

    // Paint thumb
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * progressPercent,
        progressThickness * 2,
        thumbWidth,
        thumbHeight,
      ),
      thumbPaint
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}