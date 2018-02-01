var express = require('express');
var User = require('../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /* GET sign in page. */
    router.get('/', function(req, res, next) {
        res.render('sign-in', { title: 'Sign in', nav: 'sign-in', errorMessage: req.flash('errorMessage') });
    });

    /*
     * Passport middleware handles authentication as specified in custom
     * custom userAuth signIn strategy
     */
    router.post('/', passport.authenticate('signIn', {
        failureRedirect: '/sign-in',
        successRedirect: '/',
        failureFlash: true
    }));

    return router;
};
