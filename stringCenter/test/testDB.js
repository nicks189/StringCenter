var Test = require('../test/testModel.js');
var Tab = require('../test/tabModel.js');
var tabProto = require('../middleware/tab.js');
var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";

tabProto.initTab("testTab", 4, ["E", "A", "D", "G"], 4);

function InputToDB(dbname){
  this.dbname = dbname;
  this.db;
}


InputToDB.prototype.connect = function(){
  console.log(this.dbname);
  var dbname = this.dbname;
  mongoose.connect(dbname, function(){
    console.log("connected to: " + dbname);
  });
  mongoose.Promise = global.Promise;
  this.db = mongoose.connection;
  mongoose.connection.on('error', console.error.bind(console, 'MongoDB connection error:'));
}

InputToDB.prototype.testCreate = function(name, id){
  var testDetail = {name:name, id:id};
  var test = new Test(testDetail);
  var cb = this.cb;
  test.save(function(err){
    if(err){
      console.log(err);
    } else{
      console.log(test);
      cb(null, test);
    }
  })
}


InputToDB.prototype.tabCreate = function(tab){
  var tabDetail = {tab: tab};
  var tabCreate = new Tab(tabDetail);
  var cb = this.cb;
  tabCreate.save(function(err){
    if(err){
      console.log("ERROR" + err);
      this.cb(err, null);
    } else{
      console.log(tab);
      cb(null, tab);
    }
  })
}

InputToDB.prototype.cb = function(err, res){
  if(err){
    console.log("ERROR ON CALLBACK" + err);
  } else{
    console.log("successful");
  }
}


var input = new InputToDB(mongoDB);
console.log(input);
input.connect();
input.testCreate("matt", 0);
input.tabCreate(tabProto);

module.exports = input;
