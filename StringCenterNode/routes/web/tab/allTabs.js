var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next){
    res.render('web/tab/allTabs', {title: 'Tab', nav: 'all-tabs' });
    return router;
});



module.exports = router;
