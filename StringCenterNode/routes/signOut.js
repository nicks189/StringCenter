var express = require('express');

module.exports = function(passport) {
    var router = express.Router();

    /* GET sign out page. */
    router.get('/', function(req, res, next) {
        res.render('sign-out', { title: 'Sign out', nav: 'sign-out' });
    });

    return router;
};
