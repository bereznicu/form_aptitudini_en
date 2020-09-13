import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../timerProvider.dart';

class InfoExamen extends StatefulWidget {

  @override
  _InfoExamenState createState() => _InfoExamenState();
}

class _InfoExamenState extends State<InfoExamen> {

  @override
  void initState() {
    super.initState();
    var timerInfo = Provider.of<TimerInfo>(context, listen: false);
    timerInfo.timer.cancel();

  }


  @override
  Widget build(BuildContext context) {

    var timerInfo = Provider.of<TimerInfo>(context, listen: false);
    timerInfo.timer.cancel();
  var orientation = MediaQuery.of(context).orientation;
    if(orientation == Orientation.portrait)
      return InfoExamenStatePortrait();
    else return InfoExamenStateLandscape();
  }
}

class InfoExamenStatePortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
                child: Text(
                  'Nr. of questions: 30',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),//NR INTREBARI: 30
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                child: Text(
                  'Time: 30 minutes',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),//TIMP 30
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: RaisedButton(
                  color: Colors.green,
                  splashColor: Colors.black,
                  onPressed: () {
                    var timerInfo = Provider.of<TimerInfo>(context, listen: false);
                    timerInfo.updateRemainingTime([30, 0]);
                    Navigator.of(context).pushReplacementNamed('/examen', arguments: 1.toString());
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),//START BUTTON
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width * 0.03),
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                    },
                  ),
                ),
              )//BACK BUTTON
            ],
          ),
        ),
      );
  }
}

class InfoExamenStateLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Nr. of questions: 30',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),//NR INTREBARI: 30
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025),
                child: Text(
                  'Time: 30 minutes',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),//TIMP 30
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: RaisedButton(
                  color: Colors.green,
                  splashColor: Colors.black,
                  onPressed: () {
                    var timerInfo = Provider.of<TimerInfo>(context, listen: false);
                    timerInfo.updateRemainingTime([30, 0]);
                    Navigator.of(context).pushReplacementNamed('/examen', arguments: '1');
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),//START
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: MediaQuery.of(context).size.width*0.06),
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                    },
                  ),
                ),
              )//INAPOI BUTTON
            ],
          ),
        ),
      );
  }

}