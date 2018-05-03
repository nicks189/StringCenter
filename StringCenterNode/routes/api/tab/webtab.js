var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next){
    res.render('tab', {title: 'Tab', nav: 'index' });
    return router;
});



module.exports = router;
