
class SelectedContainer {
  List<int> selected = new List<int>();
  String selectedAnswer='';
  String orientation ='';

  void initSelected() {
    this.selected = [0, 0, 0, 0, 0];
  }

  Future<void> setSelected(int index) async {
    if (this.selected[index] == 1) //Daca e selectat deja
      this.selected[index] = 0; //se deselecteaza
    else if (this.selected[index] == 0) {  //cazul in care nu e selectat
      for (int i = 0; i < 4; i++) if (selected[i] == 1) selected[i] = 0;
      this.selected[index] = 1;
    }
  }//Pentru schimbarea culorii cand se electeaza varianta

  Future<void> setSelectedQuestion(int index, String answer, String orientation) async {
    if (this.selected[index] == 1) //Daca e selectat deja
    {
        this.selected[index] = 0;
        selectedAnswer = 'unanswered';
    } //se deselecteaza
    else if (this.selected[index] == 0) {  //cazul in care nu e selectat
      for (int i = 0; i < 5; i++) if (selected[i] == 1) selected[i] = 0;
      this.selected[index] = 1;
      this.selectedAnswer = answer;
      this.orientation = orientation;
    }
  }

  String verificaExercitiu(List<String> listToShuffle, String varCorecta) {


    int selectedIndex = -1;
    for(int i = 0; i<5;i++) {
      if (this.selected[i] == 1)
        selectedIndex = i;
    }
    if(selectedIndex >= 0){
      if(listToShuffle[selectedIndex] == varCorecta)
        return '11';
      else return '10';
    }
    else return '00';
  }

}