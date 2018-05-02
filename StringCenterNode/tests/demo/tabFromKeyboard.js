var readlineSync = require('readline-sync');
var tab = require('../../middleware/tab.js');
var mongoDB = "mongodb://127.0.0.1:27017/test";

function TabFromKeyboard(){
  this.tab;
}


TabFromKeyboard.prototype.enterInformation = function(){
  console.log("Enter tab info, string count, tuning, and note count per measure (seperated by commas).");
  console.log( "Example: 'Tab info,4,EADG,16' (no spaces between arguments)");
  var input = readlineSync.question();
  input = input.toString().trim();

  if((splitinput = input.split(",")).length == 4){
    tab.initTab(splitinput[0], splitinput[1], splitinput[2], splitinput[3]);
    this.printNoteCount(tab.getNoteCountPerString());
  }
}


TabFromKeyboard.prototype.printNoteCount = function(noteCount){
  var noteCountRep = "";
  for(var i = 0; i < noteCount; i++){
    noteCountRep += "|";
  }
  console.log("enter notes, '-' for rest or a number representing a fret");
  console.log(" " + noteCountRep);
  this.enterMeasure();
}


TabFromKeyboard.prototype.enterMeasure = function(){
  for(var i = 0; i < tab.getStringCount(); i++){
    process.stdout.write(tab.getTuning()[(tab.getTuning().length - 1) - i]);
    var input = readlineSync.question();
    if(input.length == tab.getNoteCountPerString()){
      inputCharArray = input.split('');
      for(var j = 0; j < inputCharArray.length; j++){
        tab.measures[tab.measures.length - 1].strings[i].notes[j] = inputCharArray[j].toString();
      }
    } else if(input.length > tab.getNoteCountPerString()){
      i--;
      console.log("too many notes, try again");
    } else if(input.length < tab.getNoteCountPerString()){
      i--;
      console.log("not enough notes, try again");
    }
  }

  console.log("");
  console.log("New Measure? [y/n]");
  var loop = true;
  while(loop){
    var input = readlineSync.question();
    if(input == "y"){
      console.log("");
      console.log("enter measure info");
      var measureInfoInput = readlineSync.question();
      tab.addMeasure(measureInfoInput, tab.getStringCount(), tab.getTuning(), tab.getNoteCountPerString());
      printNoteCount(tab.getNoteCountPerString());
      enterMeasure();
    } else if(input == "n"){
      console.log("");
      tab.displayTab();
      this.tab = tab;
      //onsole.log(JSON.stringify(this.tab));
      console.log("--------Done--------");
      loop = false;
      //process.exit();
    } else{
      console.log("invalid input, enter again");
    }
  }
}

//var tfk = new TabFromKeyboard();
//tfk.enterInformation();

module.exports = new TabFromKeyboard();
