var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next){
    res.render('web/home', {title: 'home', nav: 'home'});
    return router;
});



module.exports = router;
