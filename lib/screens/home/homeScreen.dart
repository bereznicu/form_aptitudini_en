import 'dart:ui';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/ad_manager.dart';
import 'package:form_aptitudini_en/classes/countersExam.dart';
import 'package:form_aptitudini_en/classes/countersStorage.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CountersStorage counters = new CountersStorage();
  CountersExam countersExam = new CountersExam();
  BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    bannerAd = AdManager().bannerAd();
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    bannerAd.show(anchorType: AnchorType.bottom);
    counters.initiateCounters();
    var orientation = MediaQuery.of(context).orientation;
    if(orientation == Orientation.portrait)
      return PortraitHome();
    if(orientation == Orientation.landscape)
      return LandscapeHome();
  }
}



class PortraitHome extends StatefulWidget {
  @override
  _PortraitHomeState createState() => _PortraitHomeState();
}

class _PortraitHomeState extends State<PortraitHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075, right: MediaQuery.of(context).size.height * 0.037,),
                  child: IconButton(
                      iconSize: MediaQuery.of(context).size.height * 0.04,
                      icon: Icon(Icons.info_outline, color: Colors.black,),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/descriere');
                      }
                  ),
                ),
              ),//INFO BUTTON
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.125,
                    ),
                    child: new Text(
                        "Exam preparation",
                        style: new TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.03, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),  //MEDIU DE INVATARE TEXT
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: InkWell(
                    onTap: (){

                      Navigator.of(context).pushNamed('/categorii');
                    },
                    child: Ink(
                      width: MediaQuery.of(context).size.height * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: AssetImage("images/ExamPreparation.jpg"),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                  ),
                ),
              ), //CATEGORII TESTE BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.075,
                      left: MediaQuery.of(context).size.width * 0.125,
                    ),
                    child: new Text(
                        "Exam simulation",
                        style: new TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.03, fontWeight: FontWeight.bold)),
                  ),
                ],
              ), //SIMULARE EXAMENT TEXT
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: InkWell(
                    onTap: (){
                      CountersExam countersExam = new CountersExam();
                      countersExam.deleteExamFile();
                      countersExam.deleteQuestionsFile();
                      Navigator.pushNamed(context, '/infoExamen');
                    },
                    child: Ink(
                      width: MediaQuery.of(context).size.height * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: AssetImage("images/ExamSimulation.jpg"),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                  ),
                ),
              ),  //SIMULARE EXAMEN BUTTON
              SizedBox(height: 15.0,),
            ],
          ),
        ),
      ),
    );
  }
}



class LandscapeHome extends StatefulWidget {

  @override
  _LandscapeHomeState createState() => _LandscapeHomeState();
}

class _LandscapeHomeState extends State<LandscapeHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07, right: MediaQuery.of(context).size.width * 0.06),
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.height * 0.07,
                      icon: Icon(Icons.info_outline, color: Colors.black,),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/descriere');
                      },
                    ),
                  ),
                ),//INFO BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075, left: MediaQuery.of(context).size.width * 0.1,),
                      child: Text(
                          "Exam preparation",
                          style: new TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.07, fontWeight: FontWeight.bold)
                      ),
                    ),//MEDIU DE INVATARE TEXT
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075, right: MediaQuery.of(context).size.width * 0.12,),
                      child: Text(
                          "Exam simulation",
                          style: new TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.07, fontWeight: FontWeight.bold)
                      ),
                    ),//SIMULARE EXAMEN TEXT
                  ],
                ),
                ButtonBar(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                        child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/categorii');
                            },
                            child: Ink(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                    image: AssetImage("images/ExamPreparation.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),//MEDIU DE INVATARE BUTTON
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
                        child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              CountersExam countersExam = new CountersExam();
                              countersExam.deleteExamFile();
                              countersExam.deleteQuestionsFile();
                              Navigator.pushNamed(context, '/infoExamen');
                            },
                            child: Ink(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                    image: AssetImage("images/ExamSimulation.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    )  //SIMULARE EXAMEN BUTTON
                  ],
                )
              ],
            ),
        ),
      ),
    );

  }
}