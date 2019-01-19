import 'dart:ui';
import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({
    Key key,
    @required this.index,
    @required this.child,
    @required this.slidePercent,
    @required this.dragStart,
    @required this.dragUpdate,
    @required this.dragEnd,
    @required this.onTap,
  }) : super(key: key);

  final int index;
  final Widget child;
  final double slidePercent;
  final Function(DragStartDetails d) dragStart;
  final Function(DragUpdateDetails d) dragUpdate;
  final Function(DragEndDetails d) dragEnd;
  final Function() onTap;

  @override
  ItemScreenState createState() {
    return new ItemScreenState();
  }
}

class ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.translationValues(
        (MediaQuery.of(context).size.width * 0.8) * widget.slidePercent,
        MediaQuery.of(context).size.height * (widget.index),
        0.0
      )..scale(1-(0.3 * widget.slidePercent)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: GestureDetector(
          onHorizontalDragStart: (widget.slidePercent != 1.0)?widget.dragStart:null,
          onHorizontalDragUpdate: (widget.slidePercent != 1.0)?widget.dragUpdate:null,
          onHorizontalDragEnd: (widget.slidePercent != 1.0)?widget.dragEnd:null,
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: (widget.slidePercent > 0)?Stack(
            children: <Widget>[
              widget.child,
              Container(height: double.infinity, width: double.infinity, color: Colors.transparent,),
            ],
          ) : widget.child,
        ),
      ),
    );
  }
}