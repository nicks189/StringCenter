var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
    res.render('edit-account', { title: 'Edit Account', nav: 'edit-account' });
});

module.exports = router;
