class Tabb{
  String _info;
  List<Measure> _measures;

  Tabb(String info){
    _info = info;
    _measures = [];
  }

  void addMeasure(String info, int stringCount, int noteCount){
    _measures.add(new Measure(info, stringCount, noteCount));
  }

  void printTabb(){
    for(Measure measure in _measures){
      for(InstString string in measure.strings){
        for(String note in string.notes){
          print(note);
        }
      }
    }
  }

  get info => _info;
  get measureCount => _measures.length;
}


class Measure{
  String _info;
  List<InstString> _strings;

  Measure(String info, int stringCount, int noteCount){
    _info = info;
    _strings = [];
    for(int i = 0; i < stringCount; i++){
      _strings.add(new InstString(noteCount));
    }
  }

  void addString(int noteCount){
    _strings.add(new InstString(noteCount));
  }

  get info => _info;
  get stringCount => _strings.length;
  get strings => _strings;
}


class InstString  {
  List<String> _notes;

  InstString(int noteCount){
    _notes = [];
    for(int i = 0; i < noteCount; i++){
      _notes.add('-');
    }
  }

  void addNote(){
    _notes.add('-');
  }

  get noteCount => _notes.length;
  get notes => _notes;
}