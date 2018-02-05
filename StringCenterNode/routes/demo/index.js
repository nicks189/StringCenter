var express = require('express');

module.exports = function(passport) {
    var router = express.Router();

    /* GET home page. */
    router.get('/', function(req, res, next) {
        res.render('index', { title: 'Node demo', nav: 'index' });
    });

    return router;
};
