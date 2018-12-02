
import 'package:restless/Artists/artists_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:restless/artist_data.dart';

typedef void ScrolltoLetter(String letter);

class AlphabetArtistPicker extends StatefulWidget {
  double opacityValue;
  ScrolltoLetter scrolltoLetter;

  AlphabetArtistPicker({
    Key key,
    @required this.opacityValue,
    @required this.scrolltoLetter,
  }) : super(key: key);

  @override
  AlphabetArtistPickerState createState() {
    return new AlphabetArtistPickerState();
  }
}

class AlphabetArtistPickerState extends State<AlphabetArtistPicker> {
  List<LetterData> letters = [
    LetterData(letter: 'A', available: false),
    LetterData(letter: 'B', available: false),
    LetterData(letter: 'C', available: false),
    LetterData(letter: 'D', available: false),
    LetterData(letter: 'E', available: false),
    LetterData(letter: 'F', available: false),
    LetterData(letter: 'G', available: false),
    LetterData(letter: 'H', available: false),
    LetterData(letter: 'I', available: false),
    LetterData(letter: 'J', available: false),
    LetterData(letter: 'K', available: false),
    LetterData(letter: 'L', available: false),
    LetterData(letter: 'M', available: false),
    LetterData(letter: 'N', available: false),
    LetterData(letter: 'O', available: false),
    LetterData(letter: 'P', available: false),
    LetterData(letter: 'Q', available: false),
    LetterData(letter: 'R', available: false),
    LetterData(letter: 'S', available: false),
    LetterData(letter: 'T', available: false),
    LetterData(letter: 'U', available: false),
    LetterData(letter: 'V', available: false),
    LetterData(letter: 'W', available: false),
    LetterData(letter: 'X', available: false),
    LetterData(letter: 'Y', available: false),
    LetterData(letter: 'Z', available: false),
    LetterData(letter: '*', available: false),
  ];

  @override
  Widget build(BuildContext context) {

    for(ArtistData artist in ArtistsPageProvider.of(context).artists)
    {
      if(letters.singleWhere((l) => l.letter == artist.name.trim().toUpperCase()[0]) == null)
        letters.singleWhere((l) => l.letter == '*').available = true;
      else if(letters.singleWhere((l) => l.letter == artist.name.trim().toUpperCase()[0]).available == false)
        letters.singleWhere((l) => l.letter == artist.name.trim().toUpperCase()[0]).available = true;
    }

    return IgnorePointer(
      ignoring: widget.opacityValue == 0.0,
      child: Opacity(
        opacity: widget.opacityValue,
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width /1.30,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: letters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: FlatButton(
                        onPressed: () {
                          widget.scrolltoLetter(letters[index].letter);
                          setState(() {
                            widget.opacityValue = 0.0;
                          });
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: letters[index].letter,
                              style: TextStyle(
                                letterSpacing: 0.0,
                                color: (letters[index].available)?Theme.of(context).accentColor:Theme.of(context).primaryColorDark,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}