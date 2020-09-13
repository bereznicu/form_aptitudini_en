import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_aptitudini_en/classes/routeGenerator.dart';
import 'package:form_aptitudini_en/timerProvider.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (context) => TimerInfo(), child: MyApp(),),);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
