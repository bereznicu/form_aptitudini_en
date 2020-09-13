import 'dart:math';

import 'package:connectivity/connectivity.dart';

int generateRandomNumber(int max) {

  Random random = new Random();
  int randomNumber = random.nextInt(max);
  return randomNumber;

}

Future<bool> checkConnection() async {

  var connectivityResult = await (Connectivity().checkConnectivity());

  if(connectivityResult == ConnectivityResult.none)
    {
      return false;
    }
  else return true;

}

