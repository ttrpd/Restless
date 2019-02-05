import 'dart:ui';
import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({
    Key key,
    @required this.index,
    @required this.child,
    @required this.slidePercent,
    @required this.onArrowTap,
    @required this.onMenuTap,
    @required this.onItemScreenTap,
    this.appBarOpacity = 230,
  }) : super(key: key);

  final int index;
  final int appBarOpacity;
  final Widget child;
  final double slidePercent;
  final Function() onArrowTap;
  final Function() onMenuTap;
  final Function() onItemScreenTap;

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
      child: Material(
        color: Colors.transparent,
        elevation: 20.0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0 * widget.slidePercent)),
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
              onTap: widget.onItemScreenTap,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: <Widget>[
                  (widget.slidePercent > 0)?
                  Stack(
                    children: <Widget>[
                      widget.child,
                      Container(height: double.infinity, width: double.infinity, color: Colors.transparent,),
                    ],
                  ) : widget.child,
                  Container(
                    color: Color.fromARGB(widget.appBarOpacity, 250, 250, 250),
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 30.0,
                            splashColor: Colors.grey,
                            color: Colors.grey,
                            onPressed: widget.onArrowTap,
                          ),
                          Expanded(child: Container(),),
                          IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 30.0,
                            splashColor: Colors.grey,
                            color: Colors.grey,
                            onPressed: widget.onMenuTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}