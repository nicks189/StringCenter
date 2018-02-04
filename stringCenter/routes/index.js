var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/tabCreate', function(req, res, next){
  //tabCreate(req);
  console.log("request for tabCreate");
});

function tabCreate(tab){
  //TabFromKeyboard.enterInformation();
  console.log(tab);
  var tabDetail = {tab: tab};
  var tabModel = new Tab(tabDetail);
  tabModel.save(function(err){
    if(err){
      console.log("ERROR" + err);
      cb(err, null);
    } else{
      console.log(tab);
      cb(null, tab);
    }
  })
}

module.exports = router;
