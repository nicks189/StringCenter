const express = require('express');
const User = require('../../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            User.findOne({ username: req.body.username }, function(error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (user) {
                    return res.json({ errors: [{ message: 'Username is already taken' }] }).status(400);
                }
                if (req.body.password !== req.body.confirmPassword) {
                    return res.json({ errors: [{ message: 'Passwords don\'t match' }] }).status(400);
                }
                let newUser = new User();
                newUser.username = req.body.username;
                newUser.password = req.body.password;
                newUser.firstName = req.body.firstName;
                newUser.lastName = req.body.lastName;
                newUser.description = req.body.description;
                newUser.validateAndSave(function(errors, user) {
                    if (errors) {
                        return res.json(errors).status(400);
                    }
                    res.json(user).status(201);
                });
            });
        } else {
            res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};
