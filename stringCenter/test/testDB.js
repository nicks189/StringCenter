var Test = require('../models/testModel.js');
var Tab = require('../models/tabModel.js');
var User = require('../models/userModel.js');
var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";
var tabFromKeyboard = require('../test/tabFromKeyboard.js');

function con(tabCreate, testCreate, userCreate, tab){
  var dbname = mongoDB;
  mongoose.connect(dbname, function(){
    console.log("connected to: " + dbname);
    //testCreate("matt",69);
    //tabCreate(tab);
    userCreate("mbechtel", "6969", {tab: {info: "blah", measure:"derp"}});
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


function userCreate(username, password, tabToStore){
  var userDetail = {username: username + Math.trunc(Math.random() * 100), password: password};
  var user = new User(userDetail);
  try{
    user.tabs.push(tabToStore);
  } catch(e){
    console.log(e);
  }
  user.save(function(err){
    if(err){
      console.log(err);
    } else{
      var tab = new Tab({
        author: user._id,
        tab: tabToStore
      });


      tab.save(function(err){
        if(err) console.log(err);
        console.log(tab);
      })
      console.log(user);
      cb(null, user);
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


//tabFromKeyboard.enterInformation();
//console.log(tabFromKeyboard.tab);
con(tabCreate, testCreate, userCreate, {});
