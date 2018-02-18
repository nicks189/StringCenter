var express = require('express');
var User = require('../../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            if (req.body.password !== req.body.confirmPassword) {
                return res.json({ errors: [{ message: 'Passwords don\'t match' }] }).status(400);
            }
            var newUser = new User();
            newUser.username = req.body.username;
            newUser.password = req.body.password;
            newUser.firstName = req.body.firstName;
            newUser.lastName = req.body.lastName;
            console.log(newUser);
            newUser.validateAndSave(function (errors, user) {
                if (errors) {
                    console.log(errors);
                    return res.json(errors).status(400);
                }
                res.json(user).status(201);
            });
        } else {
            res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};
