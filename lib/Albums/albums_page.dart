import 'package:flutter/material.dart';
import 'package:restless/Artists/alphabet_artist_picker.dart';
import 'package:restless/music_provider.dart';
import 'package:restless/Albums/album_card.dart';
import 'package:restless/my_scroll_behavior.dart';

typedef double GetOffsetMethod();
typedef void SetOffsetMethod(double offset);

class AlbumsPage extends StatefulWidget
{
  final GetOffsetMethod getOffset;
  final SetOffsetMethod setOffset;
  final Function() onArrowTap;
  final Function() onMenuTap;
  final double cardWidth;


  AlbumsPage({
    Key key,
    @required this.getOffset,
    @required this.setOffset,
    @required this.cardWidth,
    @required this.onArrowTap,
    @required this.onMenuTap,
  }) : super(key: key);

  @override
  AlbumPageState createState() {
    return new AlbumPageState();
  }
}

class AlbumPageState extends State<AlbumsPage> {

  ScrollController _scrl;
  bool findingByAlpha = false;
  FocusNode focusNode = FocusNode();
  bool _searching = false;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _scrl = ScrollController(initialScrollOffset: widget.getOffset());
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).primaryColor,
            child: NotificationListener(
              onNotification: (notification) {//preserves the scroll position in list
                if(notification is ScrollNotification)
                  widget.setOffset(notification.metrics.pixels);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Albums',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 72.0,
                                fontFamily: 'Oswald',
                                height: 0.35
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: (){
                                  setState((){
                                    findingByAlpha = !findingByAlpha;
                                  });
                                },
                                icon: Icon(Icons.sort_by_alpha),
                                iconSize: 28.0,
                                color: Color.fromARGB(255, 255, 174, 0),
                              ),
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    
                                    // if(!_searching)
                                    // {
                                    //   FocusScope.of(context).requestFocus(focusNode);
                                    // }
                                    // else
                                    // {
                                    //   artists = List<ArtistData>.from(MusicProvider.of(context).artists);
                                    // }
                                    _searching = !_searching;
                                  });
                                },
                                icon: Icon(Icons.search),
                                iconSize: 28.0,
                                color: Color.fromARGB(255, 255, 174, 0),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50.0,
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedContainer(
                                    width: _searching?230.0:0.0,
                                    height: 50.0,
                                    child: TextField(
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        hintText: 'search',
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 174, 0)),
                                        ),
                                      ),
                                      style: TextStyle(
                                        decorationStyle: null,
                                        color: Theme.of(context).accentColor,
                                        fontSize: 26.0,
                                      ),
                                      cursorColor: Color.fromARGB(255, 255, 174, 0),
                                      textInputAction: TextInputAction.search,
                                      onChanged: (str){
                                        // setState(() {
                                        //   _filter = str;
                                        //   if(_filter != null && _filter.length > 0)
                                        //   {
                                        //     artists = List<ArtistData>.from(MusicProvider.of(context).artists);
                                        //     artists.retainWhere((a)=>a.name.contains(_filter));
                                        //   }
                                        // });
                                      },
                                      onSubmitted: (str){
                                        // setState(() {
                                        //   _filter = '';
                                        //   artists = List<ArtistData>.from(MusicProvider.of(context).artists);
                                        // });
                                        // FocusScope.of(context).requestFocus(new FocusNode());
                                        // print(MusicProvider.of(context).artists.length);
                                      },
                                    ),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.bounceIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8
                            ),
                            controller: _scrl,
                            
                            itemCount: MusicProvider.of(context).getAlbums().length,
                            itemBuilder: (BuildContext context, int index) {
                              String album = MusicProvider.of(context).getAlbums()[index].name;
                              AlbumCard albumSliver = AlbumCard(
                                album: MusicProvider.of(context).getAlbums()[index],
                                height: widget.cardWidth*2,
                                width: widget.cardWidth,
                              );
                              return albumSliver;
                            },
                          ),
                        ),
                        AlphabetArtistPicker(
                          visible: findingByAlpha,
                          scrolltoLetter: (l) {
                            _scrl.jumpTo(
                              MusicProvider.of(context).artists.indexOf(
                                  MusicProvider.of(context).artists.where((a) => a.name.trim().toUpperCase()[0] == l).first
                              ) * 100.0
                            );
                            findingByAlpha = false;
                          },
                        ),
                      ],
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





// Scaffold(
//   backgroundColor: Theme.of(context).accentColor,
//   body: GridView.builder(
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//     controller: _scrl,
//     itemCount: MusicProvider.of(context).getAlbums().length,
//     itemBuilder: (BuildContext context, int index) {
//       String album = MusicProvider.of(context).getAlbums()[index].name;
//       AlbumCard albumSliver = AlbumCard(
//         album: MusicProvider.of(context).getAlbums()[index],
//         length: widget.cardWidth,
//       );
//       return albumSliver;
//     },
//   ),
// );