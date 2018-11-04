import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';

class AlbumArtArea extends StatefulWidget {

  double blurValue;
  String path;

  AlbumArtArea({
    Key key,
    @required this.blurValue,
    @required this.path,
  }) : super(key: key);

  @override
  AlbumArtAreaState createState() {
    return new AlbumArtAreaState();
  }
}

class AlbumArtAreaState extends State<AlbumArtArea> {

  Future<List<Tag>> _getAlbumArt(String path) async {

    AttachedPicture pic;
    TagProcessor tp = TagProcessor();
    File f = File(path);
//    tp.getTagsFromByteArray(f.readAsBytes()).then((l) => pic = l.last.tags['APIC']);
    return tp.getTagsFromByteArray(f.readAsBytes());
  }

  ImageProvider _albumArt;

  @override
  Widget build(BuildContext context) {

    _getAlbumArt('/storage/emulated/0/Music/Little Drama/Little Drama.mp3').then(
            (List<Tag> l) {
          _albumArt = Image.memory(Uint8List.fromList(l.last.tags['APIC'].imageData)).image;
        }
    );

    return Center(// album art
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _albumArt,//AssetImage('lib/assets/art0.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: widget.blurValue,
                    sigmaY: widget.blurValue
                ),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}