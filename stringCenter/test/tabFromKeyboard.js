var readlineSync = require('readline-sync');
var tab = require('../middleware/tab.js');
enterInformation();

function enterInformation(){
  console.log("Enter tab info, string count, tuning, and note count per measure (seperated by commas).");
  console.log( "Example: 'Tab info,4,EADG,16' (no spaces between arguments)");
  var input = readlineSync.question();
  input = input.toString().trim();
  
  if((splitinput = input.split(",")).length == 4){
    console.log(splitinput);
    tab.initTab(splitinput[0], splitinput[1], splitinput[2], splitinput[3]);
    printNoteCount(tab.getNoteCountPerString());
  }  
}


function printNoteCount(noteCount){
  var noteCountRep = "";
  for(var i = 0; i < noteCount; i++){
    noteCountRep += "|";
  }
  console.log("enter notes, '-' for rest or a number representing a fret");
  console.log(noteCountRep);
  enterMeasure();
}


function enterMeasure(){  
  for(var i = 0; i < tab.getStringCount(); i++){
    var input = readlineSync.question();
    if(input.length == tab.getNoteCountPerString()){
      inputCharArray = input.split('');
      for(var j = 0; j < inputCharArray.length; j++){
        tab.measures[tab.measures.length - 1].strings[i].notes[j] = inputCharArray[j].toString();
      }
    } else{
      i--;
      console.log("too many notes try again");
    } 
  }
  
  console.log("New Measure? [y/n]");

  while(true){
    var input = readlineSync.question();
    if(input == "y"){
      tab.addMeasure(tab.info, tab.getStringCount(), tab.getTuning(), tab.getNoteCountPerString());
      enterMeasure();
    } else if(input == "n"){
      console.log("Done");
      tab.displayTab();
      process.exit()
    } else{
      console.log("invalid input, enter again");
    }
  }
}


