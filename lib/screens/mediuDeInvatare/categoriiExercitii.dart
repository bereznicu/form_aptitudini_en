import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constante.dart';

class CategoriiExercitii extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var orientation = MediaQuery.of(context).orientation;

    if(orientation == Orientation.portrait)
      return CategoriiPortrait();
    else return CategoriiLandscape();
  }
}

class CategoriiPortrait extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for(int index = 0; index < categoriiExercitiiText.length; index++)
              Column(
                children: <Widget>[
                Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05, left: MediaQuery
                        .of(context)
                        .size
                        .height * 0.023),
                    child: Text(categoriiExercitiiText[index],
                        style: new TextStyle(
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .height * 0.025, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),//CATEGORY TEXT
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/exercitii', arguments: categoriiExercitiiList[index]);
                      },
                      child: Ink(
                        width: MediaQuery.of(context).size.height * 0.45,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/"+categoriiExercitiiList[index]+".jpg"),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ),//CLICKABLE IMAGE
              ]),
            Container(
              height: 50.0,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.03),
        child: Align(
          alignment: Alignment.bottomLeft,
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
      ),//Back button
    );
  }
}

class CategoriiLandscape extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for(int index = 0; index < categoriiExercitiiText.length; index++)
              Column(
                  children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: index == 0? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.15),
                            child: Text(categoriiExercitiiText[index],
                                style: new TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.025, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Container(
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  '/exercitii', arguments: categoriiExercitiiList[index]);
                            },
                            child: Ink(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/"+categoriiExercitiiList[index]+".jpg"),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Container(
                      height: 50.0,
                    )
                  ])
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.03),
        child: Align(
          alignment: Alignment.bottomLeft,
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
      ),//Back button
    );
  }
}
