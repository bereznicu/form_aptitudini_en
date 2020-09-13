import 'package:flutter/material.dart';

import '../../constante.dart';

class Descriere extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 5.0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Instrucțiuni',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if(orientation == Orientation.portrait)
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: MediaQuery.of(context).size.width * 0.020, right: MediaQuery.of(context).size.width * 0.020),
                child: Text(
                descriptionText,
                style: TextStyle(
                  fontSize: 15,
                  height: MediaQuery.of(context).size.height * 0.0021,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.ltr,
                overflow: TextOverflow.fade,
              ),
            )
            else Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.020, left: MediaQuery.of(context).size.width * 0.020, right: MediaQuery.of(context).size.width * 0.020),
              child: Text(
                descriptionText,
                style: TextStyle(
                  fontSize: 15,
                  height: MediaQuery.of(context).size.width * 0.00175,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.ltr,
              ),
            )
          ],
        ),
      ),
    );

  }

}