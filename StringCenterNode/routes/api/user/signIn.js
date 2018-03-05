var express = require('express');
var jwt = require('jsonwebtoken');
var User = require('../../../models/user')
var config = require('../../../config/config')

module.exports = function(passport) {
    var router = express.Router();

    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            User.findOne({ username: req.body.username }, function(error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }
                if (user && User.comparePasswords(req.body.password, user.password)) {
                    // username and password match
                    var token = jwt.sign(user.id, config.session.key);
                    return res.json({ message: 'Sign in succesful', token: token }).status(200);
                }
                // username or password were wrong, we don't tell the client which one
                return res.json({ errors: [{ message: 'Invalid username or password' }] }).status(400);
            });
        } else {
            res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};
