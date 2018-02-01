var express = require('express');
var User = require('../models/user');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
    res.render('sign-in', { title: 'Sign in', nav: 'sign-in' });
});

router.post('/', function(req, res, next) {
    if (req.body.username &&
        req.body.password) {

        // Add validation here


        var newUser = {
            username: req.body.username,
            password: req.body.password,
        }

        User.authenticate(newUser, function (error, user) {
            if (error) {
                return next(error);
            } else {
                return res.redirect('/');
            }
        });
    } else {
        return next(new Error('All fields required').status(401));
    }
});

module.exports = router;
