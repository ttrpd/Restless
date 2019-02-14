import 'package:flutter/material.dart';
import 'dart:math';

class Visualizer extends StatefulWidget {
  final double width;
  final double height;
  final double currentTime;
  final double endTime;
  const Visualizer({
    Key key,
    @required this.width,
    @required this.height,
    @required this.currentTime,
    @required this.endTime,
  }) : super(key: key);

  @override
  VisualizerState createState() {
    return VisualizerState();
  }
}

class VisualizerState extends State<Visualizer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      color: Colors.transparent,
      child: CustomPaint(
        painter: VisualizerPainter(context: context),
      ),
    );
  }
}


class VisualizerPainter extends CustomPainter
{
  BuildContext context;

  VisualizerPainter({
    @required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0.0, size.height);
    Random rand = Random();
    Path path1 = Path();
    Path path2 = Path();
    Paint paint1 = Paint()..color=Theme.of(context).primaryColor.withAlpha(220)..style=PaintingStyle.fill..strokeWidth=10.0;
    Paint paint2 = Paint()..color=Theme.of(context).primaryColor.withAlpha(230)..style=PaintingStyle.fill..strokeWidth=10.0;

    path1.moveTo(0.0, 2.0);
    path1.lineTo(0.0, -(rand.nextDouble()*size.height)-(size.height/10));
    for (double i = size.width/6; i < size.width+1; i+=size.width/6) {
      path1.lineTo( i, -(rand.nextDouble()*size.height)-(size.height/10));
    }
    path1.lineTo(size.width, 2.0);
    path1.close();
    canvas.drawPath(path1, paint1);

    path2.moveTo(0.0, 0.0);
    path2.lineTo(0.0, -(rand.nextDouble()*size.height)-(size.height/10));
    for (double i = size.width/5; i < size.width+1; i+=size.width/5) {
      path2.lineTo( i, -(rand.nextDouble()*size.height)-(size.height/10));
    }
    path2.lineTo(size.width, 0.0);
    path2.close();
    canvas.drawPath(path2, paint2);
    // canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


