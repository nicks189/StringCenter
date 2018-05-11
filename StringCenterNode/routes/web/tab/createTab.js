var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next){
    res.render('web/tab/createTab', {title: 'Tab', nav: 'create-tab' });
    return router;
});

module.exports = router;
