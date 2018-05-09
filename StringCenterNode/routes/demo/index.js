const express = require('express');

module.exports = function(passport) {
    let router = express.Router();

    /* GET home page. */
    router.get('/', function(req, res, next) {
        res.render('demo/index', { title: 'Node demo', nav: 'index' });
    });

    return router;
};
