const express = require('express');
const user = require('../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    /* GET users listing. */
    router.get('/', user.isAuthenticated, function(req, res, next) {
        res.render('about', {title: 'About', nav: 'about'});
    });

    return router;
};
