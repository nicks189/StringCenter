var Tab = require('../models/tabModel.js');
var User = require('../models/user.js');
var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";
var tabFromKeyboard = require('./tabFromKeyboard.js');

function con(tabCreate, testCreate, userCreate, tab){
  var dbname = mongoDB;
  mongoose.connect(dbname, function(){
    console.log("connected to: " + dbname);
    //testCreate("matt",69);
    tabCreate(tab, "mbechtel69");
    //userCreate("mbechtel", "6969", {tab: {info: "blah", measure:"derp"}});
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


function tabCreate(tab, username){
  //TabFromKeyboard.enterInformation();
  console.log(tab);
  var tabDetail = {author_username: username, tab: tab};
  console.log(tabDetail);
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
  var userDetail = {username: username + "69", password: password};
  //Math.trunc(Math.random() * 100)
  var user = new User(userDetail);
  try{
    var tabDetail = {author_id : user._id, author_username : user.username, tab: tabToStore};
    user.tabs.push(tabDetail);
  } catch(e){
    console.log(e);
  }
  user.save(function(err){
    console.log(user.username);
    console.log(user._id);
    if(err){
      console.log("ERRRRRRRR");
      console.log(err);
    } else{
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
