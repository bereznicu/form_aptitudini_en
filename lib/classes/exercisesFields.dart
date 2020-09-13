import 'package:cloud_firestore/cloud_firestore.dart';

import 'countersExam.dart';
import 'countersStorage.dart';
class ExercisesFields {

  List<String> listToShuffle = List<String> ();
  String enunt, nr, varCorecta, varIncorecta1, varIncorecta2, varIncorecta3, varIncorecta4, selectedAnswer='', collection, document, currentExamQuestion;
  DocumentSnapshot ds;
  CountersStorage counterStorage = new CountersStorage();
  CountersExam countersExam = new CountersExam();

  Future<Map<String, dynamic>> getExerciseFields(String collection, String document) async {

    ds = await FirebaseFirestore.instance.collection(collection).doc(document).get();
    return ds.data();

  }

  Future<void> setFields(String collection) async{

    await counterStorage.getCounter(collection);
    Map<String, dynamic> data = await getExerciseFields(collection, counterStorage.counter);

    if(data!=null)
      {
        this.enunt = data['enunt'];
        print(enunt);
        this.varCorecta = data['varCorecta'];
        this.varIncorecta1 = data['varIncorecta1'];
        if (data.length >= 5) {
          this.varIncorecta2 = data['varIncorecta2'];
          this.varIncorecta3 = data['varIncorecta3'];
          if (data.length == 6) {
            this.varIncorecta4 = data['varIncorecta4'];
            listToShuffle = [this.varCorecta, this.varIncorecta1, this.varIncorecta2, this.varIncorecta3, this.varIncorecta4];
          }
          else listToShuffle = [this.varCorecta, this.varIncorecta1, this.varIncorecta2, this.varIncorecta3];
        }
        else listToShuffle = [this.varCorecta, this.varIncorecta1];
        listToShuffle.shuffle();
      }
  }

  Future<void> getExamFields(String counter) async {

    await this.countersExam.initSelectQuestionFile();
    List<String> collectionDocument = await this.countersExam.pickExamQuestion(counter);
    this.collection = collectionDocument[1];
    this.document = collectionDocument[2];
    if(collectionDocument.length > 3) this.selectedAnswer = collectionDocument[3];
    print('COLECTIA SI DOCUMENTUL:$collection$document');

    Map<String, dynamic> data = await getExerciseFields(collection, document);
    print("DATA DIN EXERCISE FIELDS: $data");
    if(collectionDocument[0] == 'false' && data != null) await this.countersExam.removeFromQuestionsFile(collection, document);
    print(data);
  countersExam.printCounters();

  this.enunt = data['enunt'];
  this.enunt = enunt.replaceAll("\n", '');
  this.varCorecta = data['varCorecta'];
  this.varIncorecta1 = data['varIncorecta1'];
  if (data.length >= 5) {
    this.varIncorecta2 = data['varIncorecta2'];
    this.varIncorecta3 = data['varIncorecta3'];
    if (data.length == 6) {
      this.varIncorecta4 = data['varIncorecta4'];
      listToShuffle = [this.varCorecta, this.varIncorecta1, this.varIncorecta2, this.varIncorecta3, this.varIncorecta4];
    }
    else listToShuffle = [this.varCorecta, this.varIncorecta1, this.varIncorecta2, this.varIncorecta3];
  }
  else listToShuffle = [this.varCorecta, this.varIncorecta1];
  listToShuffle.shuffle();
  }

}
