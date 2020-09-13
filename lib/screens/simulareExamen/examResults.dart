import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/exercisesFields.dart';

class ExamResults extends StatefulWidget {

  @override
  _ExamResultsState createState() => _ExamResultsState();
}

class _ExamResultsState extends State<ExamResults> {
  ExercisesFields exercisesFields = new ExercisesFields();
  Future future;

  @override
  void initState(){

    super.initState();
    future = _finishExam();
  }

  _finishExam() async {

    await exercisesFields.countersExam.finishExam();

  }

  @override
  Widget build(BuildContext context) {

    var orientation = MediaQuery.of(context).orientation;

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if (orientation == Orientation.portrait)
            return ExamResultsPortrait(exercisesFields: exercisesFields, enunturi: exercisesFields.countersExam.enunturi, varCorecta: exercisesFields.countersExam.varCorecta, selectedAns: exercisesFields.countersExam.selectedAns);
          else return ExamResultsLandscape(exercisesFields: exercisesFields, enunturi: exercisesFields.countersExam.enunturi, varCorecta: exercisesFields.countersExam.varCorecta, selectedAns: exercisesFields.countersExam.selectedAns);
        }
        else if(snapshot.connectionState == ConnectionState.none)
          return Text('Check your internet connection or restart the app');
        else return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait? MediaQuery.of(context).size.height * 0.1 : MediaQuery.of(context).size.height * 0.2,
                width: orientation == Orientation.portrait? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.1,
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

class ExamResultsPortrait extends StatelessWidget{

  List<String> enunturi = new List<String>();
  List<String> varCorecta = new List<String>();
  List<String> selectedAns = new List<String>();
  ExercisesFields exercisesFields = new ExercisesFields();
  int counter=0;
  double procentaj;

  ExamResultsPortrait({this.exercisesFields, this.enunturi, this.varCorecta, this.selectedAns});

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          backgroundColor: Colors.black,
          title: new Text('Leave results display?', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No', style: TextStyle(color: Colors.white),),
            ),
            new FlatButton(
              onPressed: () {
                exercisesFields.countersExam.deleteExamFile();
                exercisesFields.countersExam.deleteQuestionsFile();
                Navigator.of(context, rootNavigator: false).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              child: new Text('Yes', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      )) ?? false;
    } //SUPRASCRIEREA BUTONULUI DE BACK

    for(int i=0; i<varCorecta.length;i++)
      if(selectedAns[i] == varCorecta[i])
        counter++;
    procentaj = counter * 5 / 3;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                  child: Text('Correct answers: $counter/30(${procentaj.toStringAsFixed(1)}%)', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, color: Colors.black, fontWeight: FontWeight.bold),),
                ),
                for(int i=0; i<enunturi.length; i++)
                  Container(
                    margin: i == 0 ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05) : null,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Card(
                      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01,),
                      color: selectedAns[i] == '' || selectedAns[i]=='unanswered' ? Colors.grey : varCorecta[i] == selectedAns[i]?Colors.green : Colors.red,
                      elevation: 10.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: [
                          AutoSizeText(
                        this.enunturi[i],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),
                            minFontSize: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                            child: Text(
                              'Correct ans.: ' + this.varCorecta[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.018
                              ),
                            ),
                          ),//RASPUNS CORECT
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.008),
                            child: Text(
                              'Your ans.: ' + this.selectedAns[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height * 0.018
                              ),
                            ),
                          ),//RASPUNSUL DUMNEAVOASTRA
                        ],
                      ),//ENUNT
                    ),
                  )
              ],

            ),

          ),
        ),

      ),
    );
  }



}

class ExamResultsLandscape extends StatelessWidget{

  List<String> enunturi = new List<String>();
  List<String> varCorecta = new List<String>();
  List<String> selectedAns = new List<String>();
  ExercisesFields exercisesFields = new ExercisesFields();
  int counter=0;
  var procentaj;

  ExamResultsLandscape({this.exercisesFields, this.enunturi, this.varCorecta, this.selectedAns});

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          backgroundColor: Colors.black,
          title: new Text('Leave results display?', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No', style: TextStyle(color: Colors.white),),
            ),
            new FlatButton(
              onPressed: () {
                exercisesFields.countersExam.deleteExamFile();
                exercisesFields.countersExam.deleteQuestionsFile();
                Navigator.of(context, rootNavigator: false).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              child: new Text('Yes', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      )) ?? false;
    } //SUPRASCRIEREA BUTONULUI DE BACK

    for(int i=0; i<varCorecta.length;i++)
      if(selectedAns[i] == varCorecta[i])
        counter++;
    procentaj = (counter * 5) / 3;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
                  child: Text('Correct answers: $counter/30(${procentaj.toStringAsFixed(1)}%)', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.06, color: Colors.black, fontWeight: FontWeight.bold),),
                ),
                for(int i=0; i<enunturi.length; i++)
                  Container(
                    margin: i == 0 ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05) : null,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Card(
                      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01,),
                      color: selectedAns[i] == '' || selectedAns[i]=='unanswered' ? Colors.grey : varCorecta[i] == selectedAns[i]?Colors.green : Colors.red,
                      elevation: 10.0,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: [
                          AutoSizeText(
                            this.enunturi[i],
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.020, fontWeight: FontWeight.bold),
                            minFontSize: 13,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                            child: Text(
                              'Correct ans.: ' + this.varCorecta[i],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.03
                              ),
                            ),
                          ),//RASPUNS CORECT
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.008),
                            child: Text(
                              'Your ans.: ' + this.selectedAns[i],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height * 0.03
                              ),
                            ),
                          ),//RASPUNSUL DUMNEAVOASTRA
                        ],
                      ),//ENUNT
                    ),
                  ),
              ],

            ),

          ),
        ),

      ),
    );
  }



}