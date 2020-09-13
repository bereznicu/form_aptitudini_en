import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

import '../constante.dart';

class CountersExam {

  List<String> enunturi = new List<String>();
  List<String> varCorecta = new List<String>();
  List<String> selectedAns = new List<String>();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/countersExam.txt');
  }

  Future<File> get _selectQuestionFile async {
    final path = await _localPath;
    return File('$path/selectQuestion.txt');
  }

  Future<File> initSelectQuestionFile() async {

    final file = await _selectQuestionFile;
    String initiationString = '';
    if(await file.exists()) print("Exista, nu facem nimic");
    else{
      for(int i=0; i<categoriiExercitiiList.length;i++)
        {
          String line='';
          int nrOfDocuments = int.parse(categoriiExercitiiMap[categoriiExercitiiList[i]]);
          if(i!=0) line='\n$nrOfDocuments' + ' ' + categoriiExercitiiList[i];
          else line='$nrOfDocuments' + ' ' + categoriiExercitiiList[i];
          for(int j=1; j<nrOfDocuments + 1; j++)
            {
              line = line + ' $j';
            }
          initiationString = initiationString + line;
        }
      return await file.writeAsString(initiationString);

    }

}

  Future<List<String>> pickExamQuestion(String counter) async {

    final file = await _selectQuestionFile;
    final file1 = await _localFile;
    List<String> collectionsLeft = new List<String>();
    List<String> documentsLeft = new List<String>();

    String collection = '', document = '', selectedAns = '';
    Random random = new Random();
    bool exists = false;

    if(await file1.exists()) {
      List<String> lines2 = await file1.readAsLines();
        lines2.forEach((l) {
          if (int.parse(l.trim().split(' ')[0]) == int.parse(counter)) exists = true;
          else exists = false;
          if (exists == true) {
            collection = l.trim().split(' ')[1];
            document = l.trim().split(' ')[2];
            if (l.trim().split(' ')[4] != null) selectedAns = l.trim().split(' ')[4];
          }
        });
    }//VERIFICAM DACA INTREBAREA E FOLOSITA DEJA
    if(collection != '' && document != '') {
      if (selectedAns != '')
        return ['true', collection, document, selectedAns];
      else
        return ['true', collection, document];
    }
    //ALTFEL O LUAM RANDOM
    List<String> lines = await file.readAsLines();
    lines.forEach((l) {
      collectionsLeft.add(l.trim().split(' ')[1]);
    });
    collection = collectionsLeft[random.nextInt(collectionsLeft.length)]; //DACAN NU EXISTA LUAM RANDOM COLECTIA

    List<String> lines1 = await file.readAsLines();
        lines1.forEach((l) {
          if(l.contains(collection))
          {
            for(int i=2; i<int.parse(l.trim().split(' ')[0]) + 2; i++)
              documentsLeft.add(l.trim().split(' ')[i]);
          }
        });
        document = documentsLeft[random.nextInt(documentsLeft.length)]; //RANDOM DOCUMENTUL
      return ['false', collection, document];//ALTFEL SE ALEGE RANDOM

  }

  Future<File> removeFromQuestionsFile(String collection, String document) async {

    String counter, newLine = '', newContent='';

    final file = await _selectQuestionFile;
    List<String> lines = await file.readAsLines();
      lines.forEach((l) {
        if(l.contains(collection) && l.contains(document)){
          counter = l.trim().split(' ')[0];
          for(int i=2; i<int.parse(counter) + 3; i++){
            if(l.trim().split(' ')[i] != document)
              newLine = newLine + ' ' + l.trim().split(' ')[i];
            if(int.parse(l.trim().split(' ')[i]) == int.parse(document)) counter = (int.parse(counter) - 1).toString(); //SCAD COUNTERUL DOAR DACA AM GASIT DOCUMENTUL IN FISIER
          }
          if(int.parse(counter) > 0) l = counter + ' ' + collection + newLine;
          else l = '';
        }
      if(l != '') newContent = newContent + l + '\n';
      });
  return await file.writeAsString(newContent);
  }

  Future<File> storeExamQuestions(String counter, String _collection, String _document, String _varCor, String _selectedAns, String enunt) async {
    final file = await _localFile;
    String newContent = '';
    bool exists = false;
    String varCorectaCoded = _varCor.replaceAll(' ', '~');
    String selectedAnsCoded = _selectedAns.replaceAll(' ', '~');

    if (await file.exists()) {  //DACA IMI EXISTA FISIERUL IN CARE STOCHEZ CELE FOLOSITE
      await file.readAsLines().then((lines)  //INCEP SA-I CITESC LINIILE
      {
        lines.forEach((l) {
          if (l.trim().split(' ')[0] == counter && l.trim().split(' ')[1] == _collection && l.trim().split(' ')[2] == _document) //VERIFICAM DACA INTREBAREA E DEJA STOCATA
            {
                if (int.parse(counter) == 1)
                  l = counter + ' ' + _collection + ' ' + _document + ' ' + varCorectaCoded + ' ' + selectedAnsCoded + ' ' + enunt;
//                  l = '$counter $_collection $_document $_varCor $_selectedAns $enunt';
                else
                  {
                    l = '\n' + counter + ' ' + _collection + ' ' + _document + ' ' + varCorectaCoded + ' ' + selectedAnsCoded + ' ' + enunt;
                  }
                exists = true; //DACA E STOCATA PUNEM PE TRUE
                newContent = newContent + l;
            }
          else {
            if(l.trim().split(' ')[0] == '1') newContent = newContent + l;
            else newContent = newContent + '\n$l';
          }
        });
      });
      if (exists == false)  //DACA NU E STOCATA DAM APPEND LA NOUA INTREBARE
        return await file.writeAsString('\n$counter $_collection $_document $varCorectaCoded $selectedAnsCoded $enunt', mode: FileMode.append);  //
      else if(exists == true)
        return await file.writeAsString(newContent);  //DACA E STOCATA PUNEM INTREBAREA LA LOC (UPDATATA SAU NU)
    }
    else return await file.writeAsString('$counter $_collection $_document $varCorectaCoded $selectedAnsCoded $enunt');
  }

  Future<void> finishExam() async {

    final file = await _localFile;
    await file.readAsLines().then((lines) {
      lines.forEach((l) {
          int i=5, j=6;
          String enunt='';
          try{
            while(i < j)
            {
                enunt = enunt + l.trim().split(' ')[i] + ' ';
                j=j+1;
                i=i+1;
            }
          }catch(e){
            print(e);
          }finally{
            print(enunt);
            this.enunturi.add(enunt);
          }
          this.varCorecta.add(l.trim().split(' ')[3].replaceAll('~', ' '));
          if(l.trim().split(' ')[4] != 'null') this.selectedAns.add(l.trim().split(' ')[4].replaceAll('~', ' '));
          else this.selectedAns.add(' ');
        });
    });
  }

  Future<void> deleteExamFile() async {
    final file = await _localFile;
    if (file.existsSync()) {
      await file.delete(recursive: true,);
      print("S-A STERS1");
    }
  }

  Future<void> deleteQuestionsFile() async {
    final file = await _selectQuestionFile;
    if (file.existsSync()) {
      await file.delete(recursive: true,);
      print("S-A STERS2");
    }
  }

  Future<void> printCounters() async {
    final file = await _localFile;
    await file.readAsLines().then((lines) {
      lines.forEach((l) {
        print(l);
      });
    });
  }

}
