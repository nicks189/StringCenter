function Tab(tabInfo){
  this.info = tabInfo.name;
  this.measureCount = 1;
  this.measures = [];
  if(this.validTabInfo(tabInfo)){
      this.initTab(tabInfo.name, tabInfo.tuning.length, tabInfo.tuning, tabInfo.noteCount);
  }
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

Tab.prototype.validTabInfo = function(i){
    return (i.name && i.name.length < 100 && i.tuning && i.tuning.length >= 4 && i.noteCount && parseInt(i.noteCount) < 32);
}

Tab.prototype.initTab = function(info, stringCount, tuning, noteCount){
  this.addMeasure(undefined, info, stringCount, tuning, noteCount);
}

Tab.prototype.addMeasure = function(measure, info, stringCount, tuning, noteCount){
    if(checkMeasure(measure)){
        this.measures.push(measure);
    } else {
        this.measures.push(new Measure(info, stringCount, tuning));
        this.measures[this.measures.length - 1].initMeasure(noteCount);
        this.measureCount = this.measures.length;
    }
}

Tab.prototype.addNote = function(measureNum, note, noteNum, stringNum){
  this.measures[measureNum].strings[stringNum].notes[noteNum] = note;
}

Tab.prototype.displayTab = function(){
  for(var i = 0; i < this.getMeasureCount(); i++){
    console.log("Measure " + i + ": " + this.measures[i].info);
    for(var j = 0; j < this.getStringCount(); j++){
      var instStringToBePrinted = this.measures[i].strings[j].tuning;
      var instStringToBePrinted = this.measures[i].strings[j].tuning + " ";
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

Measure.prototype.initMeasure = function(noteCount){
  for(var i = 0; i < this.stringCount; i++){
    this.strings.push(new InstString(this.tuning[(this.tuning.length - 1) - i], noteCount));
    this.strings[i].initString(noteCount);
  }
}

function checkMeasure(measure){
    return (measure && measure.info && measure.info.length < 100 &&
            measure.stringCount && measure.stringCount > 0 && measure.stringCount < 9 &&
            measure.strings.length > 0 && measure.strings.length < 9 &&
            measure.tuning && measure.tuning.length == measure.strings.length);
}

InstString.prototype.initString = function(noteCount){
  for(var i = 0; i < noteCount; i++){
    this.notes.push("-");
  }
}
