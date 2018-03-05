const express = require('express');

module.exports = function(passport) {
    let router = express.Router();

    /* GET registration page. */
    router.get('/', function(req, res, next) {
        if (req.isAuthenticated()) {
            res.redirect('/');
        }
        res.render('register', { title: 'Register', nav: 'register', errorMessage: req.flash('errorMessage') });
    });

    /*
     * Passport middleware handles authentication as specified in custom userAuth
     * register strategy
     */
    router.post('/', passport.authenticate('register', {
        failureRedirect: '/register',
        successRedirect: '/',
        failureFlash: true
    }));

    return router;
};
