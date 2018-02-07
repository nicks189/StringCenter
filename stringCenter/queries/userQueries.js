var mongoose = require('mongoose');
var User = require('../models/userModel.js');

User.find(function(err, User){
  console.log(User);
});

/*
var query = User.findOne({'username' : 'mbechtel29'});
query.select('username password tabs');
query.exec( function(err, user){
  if(err) console.log(err);
  console.log("user");
  console.log('username: %s, password: %s, tabs: %s', user.username, user.password, user.tabs);
});


User.findOne({'username' : 'mbechtel29'}, 'username password tabs', function(err, user){
  if(err) console.log(err);
  console.log("user");
  console.log('username: %s, password: %s, tabs: %s', user.username, user.password, user.tabs);
});
*/
