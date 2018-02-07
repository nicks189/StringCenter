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


router.get('/tabs', function(req, res, next){
  Tab.find().
      where('author_username').equals('mbechtel69').exec(function(err, Tab){
          console.log(Tab);
          res.json(Tab);
      });
  });


module.exports = router;
