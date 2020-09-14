import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/exercisesFields.dart';
import 'package:form_aptitudini_en/classes/selectedContainer.dart';
import 'package:form_aptitudini_en/screens/noConnection.dart';
import 'package:provider/provider.dart';


import '../../timerProvider.dart';

class StartExamen extends StatefulWidget {

  String currentQuestion;
  StartExamen({this.currentQuestion});

  @override
  State<StatefulWidget> createState() {

    return _StartExamen(currentQuestion: currentQuestion);

  }
}

class _StartExamen extends State<StartExamen> {

  ExercisesFields exercisesFields = new ExercisesFields();
  SelectedContainer selected = new SelectedContainer();
  String verificareRaspuns = '00';
  Future documentFuture;
  String selectedAnswer;
  String currentQuestion;

  _StartExamen({Key key, this.currentQuestion});


  @override
  void initState(){
    super.initState();
    exercisesFields.currentExamQuestion = currentQuestion;
    documentFuture = _getExamFields(currentQuestion);
    selected.initSelected();
  }

  _getExamFields(String counter) async {
    await exercisesFields.getExamFields(counter);
  }

  @override
  Widget build(BuildContext context) {

    var orientation = MediaQuery.of(context).orientation;

    return FutureBuilder(
      future: documentFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError == true) return NoConnection(route: '/examen', collectionOrCurrentQuestion: currentQuestion,);
          if(selected.selectedAnswer == '')selected.selectedAnswer = exercisesFields.selectedAnswer;
          if (orientation == Orientation.portrait)
                return StartExamenPortrait(exercisesFields: exercisesFields, selected: selected, currentQuestion: currentQuestion, selectedAnswer: selected.selectedAnswer);
          else
            return StartExamenLandscape(exercisesFields: exercisesFields, selected: selected, currentQuestion: currentQuestion, selectedAnswer: selected.selectedAnswer);
        }
        else if(snapshot.connectionState == ConnectionState.none)
          return Scaffold(appBar: AppBar(title: Text('Check your internet connection or restat the app'),),);
        else return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.1: MediaQuery.of(context).size.height * 0.2,
                width: orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.1,
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
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
class StartExamenPortrait extends StatefulWidget {

  final ExercisesFields exercisesFields;
  final SelectedContainer selected;
  final String currentQuestion;
  String selectedAnswer;

  StartExamenPortrait({Key key, this.exercisesFields, this.selected, this.currentQuestion, this.selectedAnswer});

  @override
  State<StatefulWidget> createState() {
    return _StartExamenPortrait(exercisesFields, selected, currentQuestion, selectedAnswer);
  }

}

class _StartExamenPortrait extends State<StartExamenPortrait> {

  ExercisesFields exercisesFields;
  SelectedContainer selected;
  String selectedAnswer;
  final String currentQuestion;
  bool timesUp;
  Timer timer;

  _StartExamenPortrait(this.exercisesFields, this.selected, this.currentQuestion, this.selectedAnswer);

  @override
  void initState() {
    super.initState();
    for(int i=0;i<exercisesFields.listToShuffle.length;i++)
    {
      if(exercisesFields.listToShuffle[i] == selectedAnswer.replaceAll('~', ' '))
      {
        if(selected.selected[i] != 1 && selected.orientation == '') selected.setSelectedQuestion(i, exercisesFields.listToShuffle[i], 'portrait');
        break;
      }
    }
    timer = Timer.periodic(Duration(seconds: 1), (t) async {
      var timerInfo = Provider.of<TimerInfo>(context, listen: false);
      timesUp = timerInfo.timesUp();
      if(timesUp == true){
        if(timer.isActive)timer.cancel();
        await exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
        Navigator.of(context).pushReplacementNamed('/examResults');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Future<bool> _onWillPop() async {

      return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          backgroundColor: Colors.black,
          title: new Text('Leave exam?', style: TextStyle(color: Colors.white),),
          content: new Text('The progress will be lost and you won\'t get to see your answers.', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No', style: TextStyle(color: Colors.white),),
            ),//NU PARASITI BUTTON
            new FlatButton(
              onPressed: () {
                timer.cancel();
                  var timerInfo = Provider.of<TimerInfo>(context, listen: false);
                  if(timerInfo.timer.isActive)timerInfo.cancelTimer();
                  exercisesFields.countersExam.deleteExamFile();
                  exercisesFields.countersExam.deleteQuestionsFile();
                  Navigator.of(context, rootNavigator: false).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                },
              child: new Text('Yes', style: TextStyle(color: Colors.white),),
            ),//DA BUTTON
          ],
        ),
      )) ?? false;
    } //SUPRASCRIEREA BUTONULUI DE BACK

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _onWillPop,),
          title: Consumer<TimerInfo>(
            builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
                child: Text(data.getRemainingTime()[0] + ':' + data.getRemainingTime()[1],
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
              );
            },
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: AutoSizeText(
                      exercisesFields.enunt!=null? exercisesFields.enunt : 'E NULL',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.026, fontWeight: FontWeight.bold),
                      minFontSize: 15,
                    ),//ENUNT
                  ),
                ),//ENUNT
                for(int i = 0; i<exercisesFields.listToShuffle.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                        top: i == 0? MediaQuery.of(context).size.height * 0:MediaQuery.of(context).size.height * 0.010,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.setSelectedQuestion(i, exercisesFields.listToShuffle[i], 'portrait');
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: selected.selected[i] == 1? Colors.grey : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            exercisesFields.listToShuffle[i], //VARIANTA DIN DB
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.025, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),//VARIANTELE 1 - 4
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                  child: Text(
                    exercisesFields.currentExamQuestion + '/30', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02,),
                  ),
                ),//NR INTREBARE CURENTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    currentQuestion == '1' ? Container() : FloatingActionButton(
                        heroTag: "precedenta",
                        backgroundColor: Colors.black,
                        onPressed: () {
                          timer.cancel();
                          exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
                          Navigator.of(context).pushReplacementNamed('/examen', arguments: (int.parse(currentQuestion) - 1).toString());
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),//PRECEDENTA BUTTON
                    if(int.parse(currentQuestion) < 30)
                      FloatingActionButton(
                          heroTag: "urmatoarea",
                          backgroundColor: Colors.black,
                          onPressed: () {
                          timer.cancel();
                          print(exercisesFields.varCorecta);
                          exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
                          Navigator.of(context).pushReplacementNamed('/examen', arguments: (int.parse(currentQuestion) + 1).toString());
                          },
                          child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                          ),
                    )//URMATOAREA BUTTON
                    else  Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.12),
                          child: RaisedButton(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
//                        side: BorderSide(color: Colors.green),
                              ),
                              color: Colors.lightGreen,
                              onPressed: () {
                                setState(() {
                                  _incheieExamenDialog(context, exercisesFields, selected, currentQuestion, timer);
                                });
                              },
                              child: Text('Finish exam',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),//INCHEIE EXAMEN BUTTON
                  ],
                ), //PRECEDENTA && URMATOAREA BUTTONS || INCHEIE EXAMEN
              ],
            ),
          ),
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////





class StartExamenLandscape extends StatefulWidget {

  final ExercisesFields exercisesFields;
  final SelectedContainer selected;
  final String currentQuestion;
  String selectedAnswer;

  StartExamenLandscape({Key key, this.exercisesFields, this.selected, this.currentQuestion, this.selectedAnswer});

  @override
  State<StatefulWidget> createState() {
    return _StartExamenLandscape(exercisesFields, selected, currentQuestion, selectedAnswer);
  }

}

class _StartExamenLandscape extends State<StartExamenLandscape> {

  ExercisesFields exercisesFields;
  SelectedContainer selected;
  String selectedAnswer;
  final String currentQuestion;
  Timer timer;
  bool timesUp;

  _StartExamenLandscape(this.exercisesFields, this.selected, this.currentQuestion, this.selectedAnswer);

  @override
  void initState() {
    super.initState();
    for(int i=0;i<exercisesFields.listToShuffle.length;i++)
    {
      if(exercisesFields.listToShuffle[i] == selectedAnswer.replaceAll('~', ' '))
      {
        if(selected.selected[i] != 1 && selected.orientation == '')selected.setSelectedQuestion(i, exercisesFields.listToShuffle[i], 'landscape'); //daca e deja selectat de pe portrait, nu mai selectem o data, pentru ca se deselecteaza
        break;
      }
    }
    timer = Timer.periodic(Duration(seconds: 1), (t) async {
      var timerInfo = Provider.of<TimerInfo>(context, listen: false);
      timesUp = timerInfo.timesUp();
      if(timesUp == true){
        if(timer.isActive)timer.cancel();
        await exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
        Navigator.of(context).pushReplacementNamed('/examResults');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Future<bool> _onWillPop() async {
      return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          backgroundColor: Colors.black,
          title: new Text('Leave exam?', style: TextStyle(color: Colors.white),),
          content: new Text('The progress will be lost and you won\'t get to see your answers.', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Nu', style: TextStyle(color: Colors.white),),
            ),
            new FlatButton(
              onPressed: () {
                timer.cancel();
                var timerInfo = Provider.of<TimerInfo>(context, listen: false);
                if(timerInfo.timer.isActive)timerInfo.cancelTimer();
                exercisesFields.countersExam.deleteExamFile();
                exercisesFields.countersExam.deleteQuestionsFile();
                Navigator.of(context, rootNavigator: false).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              child: new Text('Da', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      )) ?? false;
    } //SUPRASCRIEREA BUTONULUI DE BACK

    return WillPopScope(

      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _onWillPop,),
          title: Consumer<TimerInfo>(
            builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.38),
                child: Text(data.getRemainingTime()[0] + ':' + data.getRemainingTime()[1],
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04)),
              );
            },
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: AutoSizeText(
                      exercisesFields.enunt,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.05, fontWeight: FontWeight.bold),
                      minFontSize: 15,
                    ),//ENUNT
                  ),
                ),//ENUNT
                for(int i = 0; i<exercisesFields.listToShuffle.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected.setSelectedQuestion(i, exercisesFields.listToShuffle[i], 'landscape');
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.09,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                          BorderRadius.all(Radius.circular(30.0)),
                          color: selected.selected[i] == 1? Colors.grey : Colors.white
                        ),
                        child: Center(
                          child: Text(
                            exercisesFields.listToShuffle[i], //VARIANTA DIN DB
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),//VARIANTELE 1 - 4
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    exercisesFields.currentExamQuestion + '/30', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03,),
                  ),
                ),//NR INTREBARE CURENTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    currentQuestion == '1' ? Container() : Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: FloatingActionButton(
                        heroTag: "precedenta",
                        backgroundColor: Colors.black,
                        onPressed: () {
                          timer.cancel();
                          exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
                          Navigator.of(context).pushReplacementNamed('/examen', arguments: (int.parse(currentQuestion) - 1).toString());
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),//PRECEDENTA BUTTON
                    if(int.parse(currentQuestion) < 30)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: FloatingActionButton(
                          heroTag: "urmatoarea",
                          backgroundColor: Colors.black,
                          onPressed: () {
                          timer.cancel();
                            exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
                            Navigator.of(context).pushReplacementNamed('/examen', arguments: (int.parse(currentQuestion) + 1).toString());
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      )//URMATOAREA BUTTON
                    else Expanded(
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.07),
                          child: RaisedButton(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Colors.lightGreen,
                            onPressed: () {
                             exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
                             if(timer.isActive)timer.cancel();
                              setState(() {
                                _incheieExamenDialog(context, exercisesFields, selected, currentQuestion, timer);
                              });
                            },
                            child: Text('Finish exam',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )//INCHEIE EXAMEN BUTTON
                  ],
                ), //PRECEDENTA && URMATOAREA BUTTONS || INCHEIE EXAMEN
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

Future<void> _incheieExamenDialog(BuildContext context, ExercisesFields exercisesFields, SelectedContainer selected, String currentQuestion, Timer timer) async {
  var timerInfo = Provider.of<TimerInfo>(context, listen: false);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Finish exam', style: TextStyle(color: Colors.white),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Finish exam and go to results display', style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No', style: TextStyle(color: Colors.white),),
          ),
          FlatButton(
            child: Text('Yes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onPressed: () async {
              if(timerInfo.timer.isActive) timerInfo.cancelTimer();
              await exercisesFields.countersExam.storeExamQuestions(currentQuestion, exercisesFields.collection, exercisesFields.document, exercisesFields.varCorecta, selected.selectedAnswer, exercisesFields.enunt);
              Navigator.of(context).pushReplacementNamed('/examResults');
            },
          ),
        ],
      );
    },
  );
}








