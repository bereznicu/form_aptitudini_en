import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/countersStorage.dart';
import 'package:form_aptitudini_en/classes/exercisesFields.dart';
import 'package:form_aptitudini_en/classes/selectedContainer.dart';
import 'package:form_aptitudini_en/screens/noConnection.dart';
import '../../constante.dart';

class StartExercitii extends StatefulWidget {
  final String collection;

  StartExercitii({this.collection});

  @override
  State<StatefulWidget> createState() {
    return _StartExercitii(collection: this.collection);
  }
}



class _StartExercitii extends State<StartExercitii> {

  Timer _timer;
  String verificareRaspuns = '00';
  bool disableTouch;
  SelectedContainer selected = new SelectedContainer();
  ExercisesFields exercisesFields = new ExercisesFields();
  final String collection;
  String counter;
  Future documentFuture;

  _StartExercitii({this.collection});

  @override
  void initState() {
    super.initState();

    disableTouch = false;
    selected.initSelected();
    documentFuture = _setFields(collection);
  }

  _setFields(String collection) async {
    await exercisesFields.setFields(collection);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return FutureBuilder(
      future: documentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError == true)
            return NoConnection(route: '/exercitii', collectionOrCurrentQuestion: collection,);
          if (orientation == Orientation.portrait)
            return StartExercitiiPortrait(exercisesFields: exercisesFields, selected: selected, collection: collection,); //PORTRAIT
          else
            return StartExercitiiLandscape(exercisesFields: exercisesFields, selected: selected, collection: collection,); //LANDSCAPE
        } else if (snapshot.connectionState == ConnectionState.none)
          return Text('Check your internet connection or restart the app');
        else
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait? MediaQuery.of(context).size.height * 0.1 : MediaQuery.of(context).size.width * 0.1,
                width: orientation == Orientation.portrait? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.height * 0.2,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ],
          );//CIRCULAR PROGRESS INDICATOR
      },
    );
  }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
class StartExercitiiPortrait extends StatefulWidget {

  ExercisesFields exercisesFields;
  SelectedContainer selected;
  final String collection;

  StartExercitiiPortrait({Key key, this.exercisesFields, this.selected, this.collection});

  @override
  State<StatefulWidget> createState() {
    return _StartExercitiiPortrait(key, exercisesFields, selected, collection);
  }
}

class _StartExercitiiPortrait extends State<StartExercitiiPortrait> {

  Timer _timer;
  ExercisesFields exercisesFields;
  SelectedContainer selected;
  String verificareRaspuns = '00';
  bool disableTouch;
  final String collection;

  _StartExercitiiPortrait(Key key, this.exercisesFields, this.selected, this.collection);

  @override
  void initState() {

    super.initState();
    disableTouch = false;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Back'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: disableTouch,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: AutoSizeText(
                      exercisesFields.enunt,
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      minFontSize: 13,
                    ),
                  ),
                ), //ENUNT
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                  child: Text(exercisesFields.counterStorage.counter + '/' +categoriiExercitiiMap[collection],),
                ),
                for(int i = 0; i<exercisesFields.listToShuffle.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      top: i == 0? MediaQuery.of(context).size.height * 0.05:MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.setSelected(i);
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                          color: verificareRaspuns == '11' && selected.selected[i] == 1 ? Colors.lightGreen[900]
                              : verificareRaspuns == '10' && selected.selected[i] == 1? Colors.redAccent[700]
                              : verificareRaspuns == '10' && selected.selected[i] == 0 && exercisesFields.listToShuffle[i] == exercisesFields.varCorecta?
                          Colors.lightGreen[900] : verificareRaspuns == '00' && selected.selected[i] == 1? Colors.grey : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            exercisesFields.listToShuffle[i], //VARIANTA DIN DB
//                        exercisesFields.listToShuffle[0],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.027, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),//VARIANTELE 1 - 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: "precedenta",
                        backgroundColor: Colors.black,
                        onPressed: () {
                          previousExercise(context, collection, exercisesFields.counterStorage);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),//PRECEDENTA BUTTON
                    RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            setState(() {

                              verificareRaspuns = selected.verificaExercitiu(exercisesFields.listToShuffle, exercisesFields.varCorecta);
                              if(verificareRaspuns != '00'){

                                disableTouch = true;
                                _timer = new Timer(const Duration(milliseconds: 1500), () {
                                  nextExercise(context, collection, exercisesFields.counterStorage);

                                });
                              }
                            });
                          },
                          child: Text(
                            'Check',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),//VERIFICA RASPUNS BUTTON
                    FloatingActionButton(
                        heroTag: "urmatoarea",
                        backgroundColor: Colors.black,
                        onPressed: () {
                          nextExercise(context, collection, exercisesFields.counterStorage);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),//URMATOAREA BUTTON
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

class StartExercitiiLandscape extends StatefulWidget {

  ExercisesFields exercisesFields;
  SelectedContainer selected;
  final String collection;

  StartExercitiiLandscape({Key key, this.exercisesFields, this.selected, this.collection});

  @override
  State<StatefulWidget> createState() {
    return _StartExercitiiLandscape(key, exercisesFields, selected, collection);
  }
}

class _StartExercitiiLandscape extends State<StartExercitiiLandscape> {

  Timer _timer;
  ExercisesFields exercisesFields;
  SelectedContainer selected;
  String verificareRaspuns = '00';
  bool disableTouch;
  final String collection;

  _StartExercitiiLandscape(Key key, this.exercisesFields, this.selected, this.collection);

  @override
  void initState() {

    super.initState();
    disableTouch = false;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Back'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: disableTouch,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.06),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: AutoSizeText(
                      exercisesFields.enunt,
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      minFontSize: 15,
                    ),
                  ),
                ), //ENUNT
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                  child: Text(exercisesFields.counterStorage.counter + '/' +categoriiExercitiiMap[collection],),
                ),
                for(int i = 0; i<exercisesFields.listToShuffle.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      top: i == 0? MediaQuery.of(context).size.height * 0.025:MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.setSelected(i);
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.8,
                        height: MediaQuery.of(context).size.width * 0.045,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                          color: verificareRaspuns == '11' && selected.selected[i] == 1 ? Colors.lightGreen[900]
                              : verificareRaspuns == '10' && selected.selected[i] == 1? Colors.redAccent[700]
                              : verificareRaspuns == '10' && selected.selected[i] == 0 && exercisesFields.listToShuffle[i] == exercisesFields.varCorecta?
                          Colors.lightGreen[900] : verificareRaspuns == '00' && selected.selected[i] == 1? Colors.grey : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            exercisesFields.listToShuffle[i], //VARIANTA DIN DB
//                        exercisesFields.listToShuffle[0],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.027, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),//VARIANTELE 1 - 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: FloatingActionButton(
                          heroTag: "precedenta",
                          backgroundColor: Colors.black,
                          onPressed: () {
                            previousExercise(context, collection, exercisesFields.counterStorage);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                        ),
                      ),
                    ), //PRECEDENTA BUTTON
                    RaisedButton(
                          color: Colors.green,
                          onPressed: () {
                            setState(() {

                              verificareRaspuns = selected.verificaExercitiu(exercisesFields.listToShuffle, exercisesFields.varCorecta);
                              if(verificareRaspuns != '00'){

                                disableTouch = true;
                                _timer = new Timer(const Duration(milliseconds: 1500), () {
                                  nextExercise(context, collection, exercisesFields.counterStorage);

                                });
                              }
                            });
                          },
                          child: Text(
                            'Check',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),//VERIFICA RASPUNS
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: FloatingActionButton(
                        heroTag: "urmatoarea",
                        backgroundColor: Colors.black,
                        onPressed: () {
                          nextExercise(context, collection, exercisesFields.counterStorage);
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),//URMATOAREA BUTTON
                  ]
                ), //VERIFICA RASPUNS BUTTON

              ],
            ),
          ),
        ),
      ),
    );
  }

}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

Future<MaterialApp> nextExercise(BuildContext context, String collection, CountersStorage countersStorage) async {

  await countersStorage.writeIncrementedCounter(collection);
  Navigator.pushReplacementNamed(context, '/exercitii', arguments: collection);

}//Navigare la urmatorul exercitiu

Future<MaterialApp> previousExercise(BuildContext context, String collection, CountersStorage countersStorage) async {

  await countersStorage.writeDecrementedCounter(collection);
  Navigator.pushReplacementNamed(context, '/exercitii', arguments: collection);

}//Navigare la exercitiul precedent
