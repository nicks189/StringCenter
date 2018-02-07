var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: configure passport to handle this; authentication; clean this up
     */
    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            User.findOne({'username': req.body.username}, function (error, user) {
                if (error) {
                    return res.json({error: 'Registration failed'}).status(500);
                } else if (user) {
                    return res.json({error: 'Username already taken'}).status(400);
                } else if (req.body.password !== req.body.confirmPassword) {
                    return res.json({error: 'Passwords don\'t match'}).status(400);
                }
                var newUser = new User();
                newUser.username = req.body.username;
                newUser.password = req.body.password;
                newUser.firstName = req.body.firstName;
                newUser.lastName = req.body.lastName;
                newUser.save(function (error) {
                    if (error) {
                        return res.json({error: 'Registration failed'}).status(500);
                    }
                    res.json({message: 'Registration successful'}).status(200);
                });
            });
        } else {
            res.json({ message: 'Invalid request' }).status(400);
        }
    });

    return router;
};
