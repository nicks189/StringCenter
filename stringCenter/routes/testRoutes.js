var express = require('express');
var router = express.Router();
var Test = require('../models/testModel.js');
var mongoose = require('mongoose');


/* GET home page. */
router.get('/', function(req, res, next) {
  Test.find(function(err, Test){
    res.json(Test);
  });
});


module.exports = router;
