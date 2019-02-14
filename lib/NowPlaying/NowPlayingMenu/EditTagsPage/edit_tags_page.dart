import 'package:flutter/material.dart';

class EditTagsPage extends StatefulWidget {
  const EditTagsPage({
    Key key,
  }) : super(key: key);

  @override
  EditTagsPageState createState() {
    return new EditTagsPageState();
  }
}

class EditTagsPageState extends State<EditTagsPage> {

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).primaryColorDark,
            margin: EdgeInsets.all(10.0),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: 'Search Tags',
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListView.builder(
            
          // ),
        ],
      ),
    );
  }
}