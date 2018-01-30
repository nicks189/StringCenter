var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

//get mongodbStuff (test db), not working yet as there is no client side
router.get('/tablist', function(req, res){
  var db = req.db;
  var collection = db.get('tabs');
  collection.find({}, {}, function(e, docs){
    res.render('tablist', {
      "tablist" : docs
    });
  });
});


module.exports = router;
