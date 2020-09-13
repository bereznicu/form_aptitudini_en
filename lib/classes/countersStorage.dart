import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../constante.dart';

class CountersStorage {
  String counter, counterExam;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counters.txt');
  }

  Future<int> getCounter(String counterType) async {
    final file = await _localFile;
    int _counter;
    await file.readAsLines().then((lines) => {
      lines.forEach((l) {
        if (l.contains(counterType))
          _counter = int.parse((l.trim().split(' '))[1]);
      })
    });
    this.counter = _counter.toString();
    return _counter;
  }

  Future<File> initiateCounters() async {
    int one = 1;
    String countersList='';
    final file = await _localFile;
    for(int i=0; i<categoriiExercitiiList.length;i++)
      {
        if(i==0) countersList = countersList + categoriiExercitiiList[i] + ' $one';
        else countersList = countersList + '\n' + categoriiExercitiiList[i] + ' $one';
      }

    if (await file.exists()) print("are continut nu facem nimic");
    else return await writeData(countersList);
  }

  Future<File> writeIncrementedCounter(String counterType) async {

    final file = await _localFile;
    int counter;
    String newCounter;
    try {
      counter = await getCounter(counterType);
      if(counter.toString() != categoriiExercitiiMap[counterType]) counter = counter + 1;
      else counter = 1;
      newCounter = counterType + ' $counter';
    } catch (e) {
      print('ERRRROOOOORRR +$e');
    }
    List<String> content = List<String>();
    await file.readAsLines().then((lines) {
      lines.forEach((l) {
        if (l.contains(counterType)) {
            l = newCounter;//\n e ca sa se scrie pe linie noua frumos
        }
        content.add(l + '\n');
      });
    });
    String concatenatedResult = concatenateStrings(content, '');
    return await writeData(concatenatedResult);
  }

  Future<File> writeDecrementedCounter(String counterType) async {
    final file = await _localFile;
    int counter;
    String newCounter;
    try {
      counter = await getCounter(counterType);
      if(counter.toString() == 1.toString()) counter = int.parse(categoriiExercitiiMap[counterType]);
      else counter = counter - 1;
      newCounter = counterType + ' $counter';
    } catch (e) {
      print('ERRRROOOOORRR +$e');
    }
    List<String> content = List<String>();
    await file.readAsLines().then((lines) {
      lines.forEach((l) {
        if (l.contains(counterType)) {
          if (counterType == 'SiruriDeNumere')
            l = newCounter; //\n e ca sa se scrie pe linie noua frumos
          else
            l = newCounter;
        }
        content.add(l + '\n');
      });
    });
    String concatenatedResult = concatenateStrings(content, '');
    return await writeData(concatenatedResult);
  }

  bool checkIfFileHasContent(File file) {
    try {
      String content = file.readAsStringSync();
      if (content.length < 10)
        return false;
      else
        return true;
    } catch (e) {
      print("EROOOOOAAAAAREEEE: $e");
    }
  }

  Future<File> writeData(String content) async {
    final file = await _localFile;
    return await file.writeAsString(content);
  }

  String concatenateStrings(List<String> list, String result) {
    list.forEach((l) {
      result = result + l;
    });
    return result;
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
