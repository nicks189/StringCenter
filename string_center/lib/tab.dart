import 'dart:convert';


class Tabb{
  String _info;
  List<Measure> _measures;

  Tabb(String info){
    _info = info;
    _measures = [new Measure("first measure", 6, 4)];
  }

  Tabb.fromJson(encodedJson){
    Map json = JSON.decode(encodedJson);
    _info = json['info'];
    num measureCount = json['measureCount'];
    _measures = [];
    for(int i = 0; i < measureCount; i++) {
      _measures.add(new Measure.fromJson(json['measures'][i]));
    }
  }

  Map toJson(){
    Map map = new Map();
    map['info'] = _info;
    map['measureCount'] = _measures.length;
    map['measures'] = _measures;
    return map;
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

  Measure.fromJson(json){
    _info = json['info'];
    num stringCount = json['stringCount'];
    _strings = [];
    for(int i = 0; i < stringCount; i++){
      _strings.add(new InstString.fromJson(json['strings'][i]));
    }
  }

  Map toJson(){
    Map map = new Map();
    map["info"] = _info;
    map['stringCount'] = _strings.length;
    map['strings'] = _strings;
    return map;
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

  InstString.fromJson(json){
    _notes = json['notes'];
  }

  void addNote(){
    _notes.add('-');
  }

  Map toJson(){
    Map map = new Map();
    map["notes"] = _notes;
    return map;
  }

  get noteCount => _notes.length;
  get notes => _notes;
}