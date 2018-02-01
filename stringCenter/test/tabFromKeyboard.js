var readlineSync = require('readline-sync');
var tab = require('../middleware/tab.js');
/*var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost:27017/tabdb", function(err, database){
console.log(tab);

  if(err) throw err;
  console.log("connected to tabdb");
  database = database.db('tabdb');
  database.collection('test', function(err, collection){

    collection.insert(tab);

    database.collection('test').count(function(err, count){
      if(err) throw err;
      console.log('Rows: ' + count);
    });
  });
});
*/
var db = require('../test/db.js');
db.connect('mongodb://localhost:27017/tabdb', function(err) {
  console.log("xx");
  if (err) {
    console.log('Unable to connect to Mongo.')
    process.exit(1)
  } else {
      console.log("connected to tabdb");
      enterInformation();
  }
});
//var tabInserter = require('../test/tabCollectionMongoDB.js');



/*var MongoClient = require('mongodb').MongoClient;

MongoClient.connect("mongodb://localhost:27017/tabdb", function(err, database){
console.log(tab);

  if(err) throw err;
  console.log("connected to tabdb");
  database = database.db('tabdb');
  database.collection('test', function(err, collection){

    collection.insert(tab);

    database.collection('test').count(function(err, count){
      if(err) throw err;
      console.log('Rows: ' + count);
    });
  });
});

var db = require('../test/db.js');
db.connect('mongodb://localhost:27017/tabdb', function(err) {
  console.log("xx");
  if (err) {
    console.log('Unable to connect to Mongo.')
    process.exit(1)
  } else {
      console.log("connected to tabdb");
      enterInformation();
  }
});
//var tabInserter = require('../test/tabCollectionMongoDB.js');
*/


function enterInformation(){
  console.log("Enter tab info, string count, tuning, and note count per measure (seperated by commas).");
  console.log( "Example: 'Tab info,4,EADG,16' (no spaces between arguments)");
  var input = readlineSync.question();
  input = input.toString().trim();

  if((splitinput = input.split(",")).length == 4){
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
  console.log(" " + noteCountRep);
  enterMeasure();
}


function enterMeasure(){
  for(var i = 0; i < tab.getStringCount(); i++){
<<<<<<< HEAD
    process.stdout.write(tab.getTuning()[i]);
=======
    process.stdout.write(tab.getTuning()[(tab.getTuning().length - 1) - i]);
>>>>>>> e7ff19ee845a186546317f14f1e627b390968570
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
  while(true){
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
<<<<<<< HEAD
=======
	  /*
>>>>>>> e7ff19ee845a186546317f14f1e627b390968570
      var tabdb = db.get().db('tabdb');
      console.log(tabdb);
      tabdb.collection('test', function(err, collection){
        //console.log(collection);
        //collection.insert(JSON.stringify(tab));

        tabdb.collection('test').count(function(err, count){
          if(err) throw err;
          console.log('Rows: ' + count);
        });
      });
<<<<<<< HEAD
      console.log("--------Done--------");
      //process.exit()
=======
	  */
      console.log("--------Done--------");
      process.exit()
>>>>>>> e7ff19ee845a186546317f14f1e627b390968570
    } else{
      console.log("invalid input, enter again");
    }
  }
}
