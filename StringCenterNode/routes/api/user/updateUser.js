const express = require('express');
const User = require('../../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    router.put('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        // req.user is set by passport, see apiAuth.js
        if (req.params.username === req.user.username) {
            User.findOne({ username: req.user.username}, function(error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (!user) {
                    return res.json({ errors: [{ message: 'Username not found' }] }).status(200);
                }
                if (typeof req.body.newUsername !== 'undefined') {
                    user.username = req.body.newUsername;
                }
                if (typeof req.body.newFirstName !== 'undefined') {
                    user.firstName = req.body.newFirstName;
                }
                if (typeof req.body.newLastName !== 'undefined') {
                    user.lastName = req.body.newLastName;
                }
                if (typeof req.body.description !== 'undefined') {
                    user.description = req.body.description;
                }
                if (typeof req.body.newPassword !== 'undefined') {
                    if (req.body.newPassword !== req.body.confirmNewPassword) {
                        return res.json({ errors: [{ message: 'Passwords don\'t match' }] }).status(400);
                    }
                    user.password = User.hashPasswordSync(req.body.newPassword);
                }
                User.findOneAndUpdate({ username: req.user.username }, {
                    $set: {
                        name: user.username,
                        firstName: user.firstName, lastName: user.lastName,
                        password: user.password, description: user.description
                    }
                }, { new: true }, function(error, updatedUser) {
                    if (error) {
                        return res.json({ errors: [{ message: 'Username is already taken' }] }).status(400);
                    }
                    res.json(updatedUser).status(200);
                });
            });
        } else {
            res.json({ errors: [{ message: 'Unauthorized' }] }).status(501);
        }
    });

    return router;
};