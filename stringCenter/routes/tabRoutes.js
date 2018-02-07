var express = require('express');
var router = express.Router();
var Tab = require('../models/tabModel.js');
var mongoose = require('mongoose');


/* GET home page. */
router.get('/', function(req, res, next) { 
  Tab.find(function(err, Tab){
    res.json(Tab);
  });
});

module.exports = router;
