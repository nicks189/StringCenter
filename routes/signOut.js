var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
    res.render('sign-out', { title: 'Sign out', nav: 'sign-out' });
});

module.exports = router;
