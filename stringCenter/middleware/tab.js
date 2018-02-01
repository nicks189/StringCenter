function Tab(){
  this.info = "";
  this.measureCount = 1;
  this.measures = [];
}

function Measure(info, stringCount, tuning){
  this.info = info;
  this.stringCount = stringCount;
  this.strings = [];
  this.tuning = tuning;
}

function InstString(tuning, noteCount){
  this.tuning = tuning;
  this.noteCount = noteCount;
  this.notes = [];
}


Tab.prototype.initTab = function(info, stringCount, tuning, noteCount){
  this.addMeasure(info, stringCount, tuning, noteCount);
}

Tab.prototype.addMeasure = function(info, stringCount, tuning, noteCount){
  this.measures.push(new Measure(info, stringCount));
  this.measures[this.measures.length - 1].initMeasure(info, stringCount, tuning, noteCount);
  this.measureCount = this.measures.length;
}

Tab.prototype.addNote = function(measureNum, note, noteNum, stringNum){
  this.measures[measureNum].strings[stringNum].notes[noteNum] = note;
}

Tab.prototype.displayTab = function(){
  for(var i = 0; i < this.getMeasureCount(); i++){
    console.log("Measure " + i + ": " + this.measures[i].info);
    for(var j = 0; j < this.getStringCount(); j++){
<<<<<<< HEAD
      var instStringToBePrinted = this.measures[i].strings[j].tuning;
=======
      var instStringToBePrinted = this.measures[i].strings[j].tuning + " ";
>>>>>>> e7ff19ee845a186546317f14f1e627b390968570
      for(var k = 0; k < this.getNoteCountPerString(); k++){
        instStringToBePrinted += this.measures[i].strings[j].notes[k];
      }
      console.log(instStringToBePrinted);
    }
    console.log("");
  }
}

Tab.prototype.getStringCount = function(){
  return this.measures[0].stringCount;
}

Tab.prototype.getMeasureCount = function(){
  return this.measureCount;
}

Tab.prototype.getNoteCountPerString = function(){
  return this.measures[0].strings[0].noteCount;
}

Tab.prototype.getTuning = function(){
  return this.measures[0].tuning;
}

Measure.prototype.initMeasure = function(info, stringCount, tuning, noteCount){
  this.info = info;
  this.tuning = tuning;
  for(var i = 0; i < stringCount; i++){
    this.strings.push(new InstString(tuning[(tuning.length - 1) - i], noteCount));
    this.strings[i].initString(noteCount);
  }
}

InstString.prototype.initString = function(noteCount){
  for(var i = 0; i < noteCount; i++){
    this.notes.push("-");
  }
}

var tab = new Tab();

module.exports = tab;
