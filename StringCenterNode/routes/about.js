var express = require('express');

module.exports = function(passport) {
    var router = express.Router();

    /* GET users listing. */
    router.get('/', function (req, res, next) {
        res.render('about', {title: 'About', nav: 'about'});
    });

    return router;
};
