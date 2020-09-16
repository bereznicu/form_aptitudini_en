import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/exercisesFields.dart';
import 'package:form_aptitudini_en/timerProvider.dart';
import 'package:provider/provider.dart';

class NoConnection extends StatelessWidget {

  String route, collectionOrCurrentQuestion;
  NoConnection({this.route, this.collectionOrCurrentQuestion});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    ExercisesFields exercisesFields = new ExercisesFields();

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
                var timerInfo = Provider.of<TimerInfo>(context, listen: false);
                if(timerInfo.timer.isActive)timerInfo.cancelTimer();
                exercisesFields.countersExam.deleteExamFile();
                exercisesFields.countersExam.deleteQuestionsFile();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: new Text('Yes', style: TextStyle(color: Colors.white),),
            ),//DA BUTTON
          ],
        ),
      )) ?? false;
    }

    if(orientation == Orientation.portrait)
      return WillPopScope(
        onWillPop: route == '/examen'? _onWillPop : null,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                    width: MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/noconnection.png'),
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.black,
                    child: Text('Reload', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(route, arguments: collectionOrCurrentQuestion);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    else return WillPopScope(
      onWillPop: route == '/examen'? _onWillPop : null,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/noconnection.png'),
                        fit: BoxFit.cover,
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  color: Colors.black,
                  child: Text('Reload', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(route, arguments: collectionOrCurrentQuestion);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
