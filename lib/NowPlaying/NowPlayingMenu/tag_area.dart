import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';

class TagArea extends StatelessWidget {
  const TagArea({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final Set<TrackTag> tags;

  @override
  Widget build(BuildContext context) {

    Set<Widget> tagChips = Set<Widget>();

    for(var tag in tags)
    {
      tagChips.add(
        Chip(
          backgroundColor: Theme.of(context).primaryColor,
          label: Text(
            tag.content, 
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      );
    }

    return Padding(// tags area
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.maxFinite,
        height: 60.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    child: RichText(
                      text: TextSpan(
                        text: 'Tags',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
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
                IconButton(
                  onPressed: (){},
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: tagChips.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
