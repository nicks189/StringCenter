var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: configure passport to handle this; authentication
     */
    router.post('/', function(req, res, next) {
        console.log(req.params);
        console.log(req.body);
        if (req.body.username && req.body.password) {
            if (req.body.password !== req.body.confirmPassword) {
                return res.json({ error: 'Passwords don\'t match' }).status(400);
            }
            var newUser = new User();
            newUser.username = req.body.username;
            newUser.password = req.body.password;
            newUser.firstName = req.body.firstName;
            newUser.lastName = req.body.lastName;
            console.log(newUser);
            newUser.save(function (error) {
                if (error) {
                    console.log(error.errors);
                    return res.json({ error: 'Something went wrong' }).status(400);
                }
                res.json({ message: 'Registration successful' }).status(200);
            });
        } else {
            res.json({ message: 'Invalid request' }).status(400);
        }
    });

    return router;
};
