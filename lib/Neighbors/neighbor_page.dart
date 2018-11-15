

import 'package:flutter/material.dart';
import 'package:restless/Neighbors/neighbor.dart';

class NeighborPage extends StatefulWidget
{
  @override
  NeighborPageState createState() {
    return new NeighborPageState();
  }
}

class NeighborPageState extends State<NeighborPage> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          text: TextSpan(
            text: 'Neighbors',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Neighbor(path:'lib/assets/art0.jpg'),
            Neighbor(path:'lib/assets/art1.jpg'),
            Neighbor(path:'lib/assets/art2.jpg'),
            Neighbor(path:'lib/assets/art3.jpg'),
            Neighbor(path:'lib/assets/art4.jpg'),
            Neighbor(path:'lib/assets/art5.jpg'),
            Neighbor(path:'lib/assets/art6.jpg'),
            Neighbor(path:'lib/assets/art7.jpg'),
            Neighbor(path:'lib/assets/art8.jpg'),
            Neighbor(path:'lib/assets/art9.jpg'),
            Neighbor(path:'lib/assets/art10.jpg'),
            Neighbor(path:'lib/assets/art11.jpg'),
            Neighbor(path:'lib/assets/art12.jpg'),
            Neighbor(path:'lib/assets/art13.jpg'),
            Neighbor(path:'lib/assets/art14.jpg'),
            Neighbor(path:'lib/assets/art15.jpg'),
            Neighbor(path:'lib/assets/art16.jpg'),
            Neighbor(path:'lib/assets/art17.jpg'),
            Neighbor(path:'lib/assets/art18.jpg'),
            Neighbor(path:'lib/assets/art19.jpg'),
            Neighbor(path:'lib/assets/art20.jpg'),
            Neighbor(path:'lib/assets/art21.jpg'),
          ],
        ),
      ),
    );
  }
}