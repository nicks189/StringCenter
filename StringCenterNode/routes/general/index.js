const express = require('express');

module.exports = function(passport) {
    let router = express.Router();

    /* GET users listing. */
    router.get('/', function(req, res, next) {
        res.redirect('/web/home');
    });

    return router;
};