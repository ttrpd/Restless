import 'dart:ui';
import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({
    Key key,
    @required this.text,
    @required this.onPressed,
    @required this.enabled,
    @required this.selected,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool enabled;
  final bool selected;

  @override
  MenuItemState createState() {
    return new MenuItemState();
  }
}

class MenuItemState extends State<MenuItem> {

  Color textColor;

  @override
  Widget build(BuildContext context) {
    textColor = Theme.of(context).accentColor;
    if(widget.selected)
      textColor = Theme.of(context).primaryColorLight;
    
    if(!widget.enabled)
      textColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: FlatButton(
        splashColor: Colors.transparent,
        onPressed: widget.enabled?widget.onPressed:null,
        child: RichText(
          text: TextSpan(
            text: widget.text,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontStyle: FontStyle.normal,
              // fontWeight: FontWeight.w100,
              color: textColor,
              fontSize: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}