import 'dart:convert';
import 'dart:io';


class Tabb{
  String _info;
  String _tuning;
  num _stringCount;
  List<Measure> _measures;

  Tabb(String info, String tuning){
    _info = info;
    _measures = [new Measure("first measure", tuning.length, 4, tuning)];
    _tuning = tuning;
    _stringCount = tuning.length;
  }

  Tabb.fromJson(encodedJson){
    Map json = JSON.decode(encodedJson);
    _info = json['info'];
    _tuning = json['tuning'];
    num measureCount = json['measureCount'];
    _measures = [];
    for(int i = 0; i < measureCount; i++) {
      _measures.add(new Measure.fromJson(json['measures'][i]));
    }
  }

  Map toJson(){
    Map map = new Map();
    map['info'] = _info;
    map['tuning'];
    map['measureCount'] = _measures.length;
    map['measures'] = _measures;
    return map;
  }

  void addMeasure(String info, int noteCount){
    _measures.add(new Measure(info, _stringCount, noteCount, _tuning));
  }

  void printTabb(){
    String temp = "";
    for(Measure measure in _measures){
      print(measure.info);
      for(InstString string in measure.strings){
        temp += string.tuning + ' ';
        for(String note in string.notes){
          temp += note;
        }
        print(temp);
        temp = "";
      }
    }
  }

  get info => _info;
  get tuning => _tuning;
  get measureCount => _measures.length;
}


class Measure{
  String _info;
  String _tuning;
  List<InstString> _strings;

  Measure(String info, int stringCount, int noteCount, String tuning){
    _info = info;
    _tuning = tuning;
    _strings = [];
    for(int i = 0; i < stringCount; i++){
      _strings.add(new InstString(noteCount, tuning[i]));
    }
  }

  Measure.fromJson(json){
    _info = json['info'];
    _tuning = json['tuning'];
    num stringCount = json['stringCount'];
    _strings = [];
    for(int i = 0; i < stringCount; i++){
      _strings.add(new InstString.fromJson(json['strings'][i]));
    }
  }

  Map toJson(){
    Map map = new Map();
    map['info'] = _info;
    map['tuning'] = _tuning;
    map['stringCount'] = _strings.length;
    map['strings'] = _strings;
    return map;
  }

  void addString(int noteCount, String tuning){
    _strings.add(new InstString(noteCount, tuning));
  }

  get info => _info;
  get tuning => _tuning;
  get stringCount => _strings.length;
  get strings => _strings;
}


class InstString  {
  List<String> _notes;
  String _tuning;

  InstString(int noteCount, String tuning){
    _notes = [];
    _tuning = tuning;
    for(int i = 0; i < noteCount; i++){
      _notes.add('-');
    }
  }

  InstString.fromJson(json){
    _notes = json['notes'];
    _tuning = json['tuning'];
  }

  void addNote(){
    _notes.add('-');
  }

  Map toJson(){
    Map map = new Map();
    map['notes'] = _notes;
    map['tuning'] = _tuning;
    return map;
  }

  get tuning => _tuning;
  get noteCount => _notes.length;
  get notes => _notes;
}