


import 'package:flutter/material.dart';

class DiamondFrame extends StatelessWidget {

  const DiamondFrame({
    Key key,
    @required this.height,
    @required this.child,
    @required this.padding,
  }) : super(key: key);

  final double height;
  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:16.0, right:8.0),
      child: ClipPath(
        clipper: DiamondClipper(),
        child: Container(
          width: height,
          height: height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: ClipPath(
              clipper: DiamondClipper(),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class DiamondClipper extends CustomClipper<Path>
{

  DiamondClipper({
    Key key,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width/2, 0.0);
    path.lineTo(size.width, size.height/2);
    path.lineTo(size.width/2, size.height);
    path.lineTo(0.0, size.height/2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}