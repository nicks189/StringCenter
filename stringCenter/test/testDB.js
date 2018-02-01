var Test = require('../test/testModel.js');
var Tab = require('../test/tabModel.js');
var tabProto = require('../middleware/tab.js');
var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";

mongoose.connect(mongoDB, function(){
  console.log("connected to: " + mongoDB);
});

mongoose.Promise = global.Promise;
var db = mongoose.connection;
mongoose.connection.on('error', console.error.bind(console, 'MongoDB connection error:'));

tabProto.initTab("testTab", 4, ["E", "A", "D", "G"], 4);

testCreate("matt", 0);
tabCreate(tabProto);

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
  var tabDetail = {tab: tab};
  var tabCreate = new Tab(tabDetail);
  tabCreate.save(function(err){
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
