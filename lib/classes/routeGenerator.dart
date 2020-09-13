import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/screens/descriere/descriere.dart';
import 'package:form_aptitudini_en/screens/home/homeScreen.dart';
import 'package:form_aptitudini_en/screens/mediuDeInvatare/categoriiExercitii.dart';
import 'package:form_aptitudini_en/screens/mediuDeInvatare/startExercitii.dart';
import 'package:form_aptitudini_en/screens/simulareExamen/examResults.dart';
import 'package:form_aptitudini_en/screens/simulareExamen/infoExamen.dart';
import 'package:form_aptitudini_en/screens/simulareExamen/startExamen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    final String args = settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/categorii':
        return MaterialPageRoute(builder: (_) => CategoriiExercitii());
      case '/exercitii':
        return MaterialPageRoute(builder: (_) => StartExercitii(collection: args,));
      case '/descriere':
        return MaterialPageRoute(builder: (_) => Descriere());
      case '/infoExamen':
        return MaterialPageRoute(builder: (_) => InfoExamen());
      case '/examen':
        return MaterialPageRoute(builder: (_) => StartExamen(currentQuestion: args));
      case '/examResults':
        return MaterialPageRoute(builder: (_) => ExamResults());
    }
  }
}