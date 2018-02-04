var Async = require('async');
var Test = require('../test/testModel.js');
var Tab = require('../test/tabModel.js');
var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";
var tabFromKeyboard = require('../test/tabFromKeyboard.js');

function con(tabCreate, testCreate, tab){
  var dbname = mongoDB;
  mongoose.connect(dbname, function(){
    console.log("connected to: " + dbname);
    testCreate("matt",69);
    tabCreate(tab);
  });

  console.log("afterconnect");
  mongoose.Promise = global.Promise;
  mongoose.connection.on('error', console.error.bind(console, 'MongoDB connection error:'));
}




function testCreate(name, id){
  var testDetail = {name:name, id:id};
  var test = new Test(testDetail);
  test.save(function(err){
    if(err){
      console.log(err);
    } else{
      console.log(test);
      cb(null, test);
    }
  })
}


function tabCreate(tab){
  //TabFromKeyboard.enterInformation();
  console.log(tab);
  var tabDetail = {tab: tab};
  var tabModel = new Tab(tabDetail);
  tabModel.save(function(err){
    if(err){
      console.log("ERROR" + err);
      cb(err, null);
    } else{
      console.log(tab);
      cb(null, tab);
    }
  })
}

function cb(err, res){
  if(err){
    console.log("ERROR ON CALLBACK" + err);
  } else{
    console.log("successful");
  }
}

/*
Async.series([
  con(),
  tabFromKeyboard.enterInformation(),
  tabCreate(tabFromKeyboard.tab)
], function(err, res){
  if (err) {
       console.log('FINAL ERR: '+err);
   }
   else {
       console.log('BOOKInstances: '+bookinstances);
   }
   // All done, disconnect from database
   mongoose.connection.close();
});
*/
tabFromKeyboard.enterInformation();
con(tabCreate, testCreate, tabFromKeyboard.tab);
//testCreate("matt", 69);
//tabCreate();
