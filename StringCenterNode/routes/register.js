var express = require('express');
var User = require('../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /* GET registration page. */
    router.get('/', function(req, res, next) {
        res.render('register', { title: 'Register', nav: 'register' });
    });

    router.post('/', function(req, res, next) {
        if (req.body.username &&
            req.body.password &&
            req.body.confirmPassword) {

            // Add validation here


            var newUser = {
                username: req.body.username,
                password: req.body.password,
                confirmPassword: req.body.confirmPassword,
                firstName: req.body.firstName,
                lastName: req.body.lastName
            }

            User.create(newUser, function (error, user) {
                if (error) {
                    return res.redirect('/register');
                } else {
                    return res.redirect('/');
                }
            });
        } else {
            return next(new Error('All fields required').status(401));
        }
    });

    return router;
};
