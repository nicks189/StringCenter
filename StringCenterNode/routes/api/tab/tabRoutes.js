var express = require('express');
var router = express.Router();
var Tab = require('../../../models/tabModel.js');
var mongoose = require('mongoose');
var cb = require('../../../middleware/mongoCallback.js');
var validateTab = require('../../../auth/tabAuth.js');


//get all tabs
router.get('/', function(req, res, next) {
  Tab.find(function(err, Tab){
    if (err) {
      return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
    }
    res.json(Tab).status(200);
  });
});

//get tabs from dummy user
router.get('/tabs', function(req, res, next){
  Tab.find().
      where('author_username').equals('mbechtel69').exec(function(err, Tab){
          if (err) {
            return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
          }
          res.json(Tab).status(200);
      });
});

//get tabs with user name sent in post body as author_username
router.post('/findTabsByAuthorName', function(req, res, next){
  console.log(req.body);
  Tab.find().
      where('author_username').equals(req.body.author_username).exec(function(err, Tab){
          if (err) {
            return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
          }
          res.json(Tab).status(200);
      });
});

//create new tab with json data from post
router.post('/createTab', function(req, res, next){
  if(validateTab.valid(req.body.tab)){
    res.send(tabCreate(req.body.author_username, req.body.tab_name, req.body.tab));
  } else{
    res.json({ errors: [{ message: 'Invalid tab' }] }).status(400);
  }
});

//add a tab to the database
function tabCreate(username, tabName, tabString){
  var tab = JSON.parse(tabString);
  var tabDetail = {author_username: username, tab_name : tabName, tab: tab};
  var tabModel = new Tab(tabDetail);
  console.log(tabModel.save(function(err, tab){
    if(err){
      console.log("ERROR" + err);
      cb.cb(err, null);
      return tab;
    } else{
      console.log(tab);
      cb.cb(null, tab);
      return tab;
    }
  }));
}




module.exports = router;
