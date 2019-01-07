import 'package:flutter/material.dart';
import 'package:restless/NowPlaying/now_playing_provider.dart';

class TagArea extends StatelessWidget {
  const TagArea({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<Widget> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(// tags area
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.maxFinite,
        height: 186.0,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: FlatButton(
                splashColor: Colors.transparent,
                child: RichText(
                  text: TextSpan(
                    text: 'Tags',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  print('tags!');
                },
              ),

            ),
            Flexible(
              child: Wrap(
                spacing: 3.0,
                children: tags,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
