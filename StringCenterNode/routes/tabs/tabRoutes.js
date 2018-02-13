var express = require('express');
var router = express.Router();
var Tab = require('../models/tabModel.js');
var mongoose = require('mongoose');
var cb = require('../middleware/mongoCallback.js');
var validateTab = require('../auth/tabAuth.js');


//get all tabs
router.get('/', function(req, res, next) {
  Tab.find(function(err, Tab){
    res.json(Tab);
  });
});

//get tabs from dummy user
router.get('/tabs', function(req, res, next){
  Tab.find().
      where('author_username').equals('mbechtel69').exec(function(err, Tab){
          res.json(Tab);
      });
});

//get tabs with user name sent in post body as author_username
router.post('/findTab', function(req, res, next){
  console.log(req.body);
  Tab.find().
      where('author_username').equals(req.body.author_username).exec(function(err, Tab){
          res.json(Tab);
      });
});

//create new tab with json data from post
router.post('/createTab', function(req, res, next){
  if(validateTab.valid(tab)){
    res.send(tabCreate(JSON.parse(req.body.tab), req.body.author_username));
  } else{
    res.send("invalid tab");
  }
});


function tabCreate(tab, username){
  console.log(tab);
  var tabDetail = {author_username: username, tab: tab};
  console.log(tabDetail);
  var tabModel = new Tab(tabDetail);
  tabModel.save(function(err, tab){
    if(err){
      console.log("ERROR" + err);
      cb.cb(err, null);
      return "Tab Creation Failed"
    } else{
      console.log(tab);
      cb.cb(null, tab);
      return "Tab Creation Successful" + tab;
    }
  });
}




module.exports = router;
