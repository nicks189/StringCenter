var express = require('express');
var router = express.Router();
var User = require('../models/userModel.js');
var mongoose = require('mongoose');


//get user 'dummy user as of now'
router.get('/', function(req, res, next) {
  User.findOne({'username' : 'mbechtel29'}, 'username password tabs', function(err, user){
    if(err) console.log(err);
    console.log("user");
    console.log('username: %s, password: %s, tabs: %s', user.username, user.password, user.tabs);
    res.json(user);
  });
});


//get user tabs 'dummy user as of now'
router.get('/tabs', function(req, res, next) {
  User.findOne({'username' : 'mbechtel29'}, 'username password tabs', function(err, user){
    if(err) console.log(err);
    console.log("user");
    console.log('username: %s, password: %s, tabs: %s', user.username, user.password, user.tabs);
    res.json(user.tabs);
  });
});

module.exports = router;
