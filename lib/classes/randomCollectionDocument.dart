import 'package:form_aptitudini_en/functii/functii.dart';
import '../constante.dart';

class RandomCollectionDocument {

  String collection, document;

  void setRandomCollectionDocument() {

    this.collection = generateRandomNumber(11).toString();
    this.document = generateRandomNumber(int.parse(categoriiExercitiiMap[this.collection])).toString();

  }

}