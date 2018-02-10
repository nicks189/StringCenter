var express = require('express');
var router = express.Router();
var Tab = require('../models/tabModel.js');
var mongoose = require('mongoose');
var cb = require('../middleware/mongoCallback.js');


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
  res.send(tabCreate(JSON.parse(req.body.tab), req.body.author_username));
});


function tabCreate(tab, username){
  console.log(tab);
  var tabDetail = {author_username: username, tab: tab};
  console.log(tabDetail);
  var tabModel = new Tab(tabDetail);
  tabModel.save(function(err){
    if(err){
      console.log("ERROR" + err);
      cb.cb(err, null);
      return "Tab Creation Failed"
    } else{
      console.log(tab);
      cb.cb(null, tab);
      var createdTab = "";
      Tab.find().
          where('author_username').equals(username).exec(function(err, Tab){
              createdTab += Tab;
          });;
      return "Tab Creation Successful" + createdTab;
    }
  });
}




module.exports = router;
