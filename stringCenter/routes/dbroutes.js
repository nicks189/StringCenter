var express = require('express');
var router = express.Router();
var Test = require('../models/testModel.js');
var mongoose = require('mongoose');


/* GET home page. */
router.get('/', function(req, res, next) {
  var testDetail = {name:"routedBOI", id:69};
  var test = new Test(testDetail);
  test.save(function(err){
    if(err){
      console.log(err);
    } else{
      console.log(test);
      cb(null, test);
    }
  });

  var collections = mongoose.connections[0].collections;
  var names = [];
  console.log(mongoose.connections[0].collections);
  Object.keys(collections).forEach(function(k) {
      names.push(k);
  });

  console.log(names);
  res.send(Test.find());
});


function cb(err, res){
  if(err){
    console.log("ERROR ON CALLBACK" + err);
  } else{
    console.log("successful");
  }
}



module.exports = router;
