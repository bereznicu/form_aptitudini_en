import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerInfo extends ChangeNotifier
{
  int minutes, seconds;
  Timer timer = new Timer(Duration(seconds: 1000), null);
  bool timesDone;

  bool timesUp() {

    if(minutes <= -1)
      {
        timesDone = true;
        notifyListeners();
        timesDone = false;
        if(timer.isActive)timer.cancel();
        return true;
      }
    return timesDone;
  }

  List<String> getRemainingTime() {

    List<String> minutesSeconds = new List<String>();
    if(minutes > 9)
      minutesSeconds.add(minutes.toString());
    else minutesSeconds.add('0' + minutes.toString());
    if(seconds > 9)
      minutesSeconds.add(seconds.toString());
    else minutesSeconds.add('0' + seconds.toString());
    return minutesSeconds;

  }
  cancelTimer() => timer.cancel();

  updateTime(int minutes, int seconds) {

    timer = Timer.periodic(Duration(seconds: 1), (t) {

      if(this.seconds > 0){
        this.seconds--;
      }
      else if(this.seconds == 0 && this.minutes > 0){
        this.minutes --;
        this.seconds = 59;
      }
      else if(this.seconds ==0 && this.minutes == 0)
        if(timer.isActive) timer.cancel();
      notifyListeners();
    });

  }

  updateRemainingTime(List<int> time)
  {
    this.minutes = time[0];
    this.seconds = time[1];
    updateTime(minutes, seconds);
  }
}