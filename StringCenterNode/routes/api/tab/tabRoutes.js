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
router.post('/findTab', function(req, res, next){
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
  // TODO -- this doesn't work but I'm not sure how to fix it
  // Also, I think we should include author_name in the tab object
  if(validateTab.valid(tab)){
    res.json(tabCreate(JSON.parse(req.body.tab), req.body.author_username)).status(200);
  } else{
    res.json({ errors: [{ message: 'Invalid tab' }] }).status(400);
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
