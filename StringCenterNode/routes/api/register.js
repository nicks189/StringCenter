var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: configure passport to handle this; authentication
     */
    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            if (req.body.password !== req.body.confirmPassword) {
                return res.json({ error: 'Passwords don\'t match' }).status(400);
            }
            var newUser = new User();
            newUser.username = req.body.username;
            newUser.password = req.body.password;
            newUser.firstName = req.body.firstName;
            newUser.lastName = req.body.lastName;
            newUser.save(function (error) {
                if (error) {
                    return res.json({ error: 'Username is already taken' }).status(400);
                }
                res.json({ message: 'Registration successful' }).status(200);
            });
        } else {
            res.json({ message: 'Invalid request' }).status(400);
        }
    });

    return router;
};
