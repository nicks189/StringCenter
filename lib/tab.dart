import 'dart:convert';


class Tabb{
  String _title;
  String _info;
  String _tuning;
  num _stringCount;
  List<Measure> _measures;

  Tabb(String title, String info, String tuning){
    _title = title;
    _info = info;
    _measures = [];
    _tuning = tuning;
    _stringCount = tuning.length;
  }

  Tabb.fromJson(encodedJson){
    Map json = JSON.decode(encodedJson);
    Map t = json['tab'];
    _title = json['tab_name'];
    _info = t['info'];
    _tuning = t['tuning'];
    num measureCount = int.parse(t['measureCount']);
    _measures = [];
    for(int i = 0; i < measureCount; i++) {
      _measures.add(new Measure.fromJson(t['measures'][i]));
    }
  }

  Map toJson(){
    Map tabMap = new Map();
    Map map = new Map();
    map['info'] = _info;
    map['tuning'] = _tuning;
    map['measureCount'] = _measures.length.toString();
    map['measures'] = _measures;
    tabMap['author_username'] = "newtestuser";
    tabMap['tab_name'] = _title;
    tabMap['tab'] = map;
    return tabMap;
  }

  void createMeasure(String info, int noteCount){
    _measures.add(new Measure(info, _stringCount, noteCount, _tuning));
  }

  void addMeasure(Measure m) {
    _measures.add(m);
  }

  void printTabb(){
    print(_title);
    print(_info);
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

  String tabToString(){
    String t = "";
    t = t + _title + '\n';
    t = t + _info + '\n';
    String temp = "";
    for(Measure measure in _measures){
      t = t + measure.info + '\n';
      for(InstString string in measure.strings){
        temp += string.tuning + ' ';
        for(String note in string.notes){
          temp += note;
        }
        t = t + temp + '\n';
        temp = "";
      }
    }
    return t;
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
    num stringCount = int.parse(json['stringCount']);
    _strings = [];
    for(int i = 0; i < stringCount; i++){
      _strings.add(new InstString.fromJson(json['strings'][i]));
    }
  }

  Map toJson(){
    Map map = new Map();
    map['info'] = _info;
    map['tuning'] = _tuning;
    map['stringCount'] = _strings.length.toString();
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