const express = require('express');

module.exports = function(passport) {
    let router = express.Router();

    /* GET sign out page. */
    router.get('/', function(req, res, next) {
        req.logout();
        res.redirect('/');
    });

    return router;
};
