const express = require('express');
const User = require('../../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    /*
     * --- Get a list of all users ---
     * TODO: add authorization so only mods/admins can access this;
     * limit this to some max number of users;
     */
    router.get('/all', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.find({}, { password: 0 }, function(error, users) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (users.length === 0) {
                return res.json({ errors: [{ message: 'No users found' }] }).status(200);
            }
            // sort users alphabetically
            users.sort(function(a, b){
                return a.username.toLowerCase().localeCompare(b.username.toLowerCase());
            });
            res.json({ users: users }).status(200);
        });
    });

    /*
     * --- Get user by current authentication ---
     */
    router.get('/info', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.findOne({ username: req.user.username}, { password: 0 }, function(error, user) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!user) {
                return res.json({ errors: [{ message: 'Username not found' }] }).status(200);
            }
            res.json(user).status(200);
        });
    });

    /*
     * --- Get user by username ---
     */
    router.get('/info/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.findOne({ username: req.params.username}, { password: 0 }, function(error, user) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!user) {
                return res.json({ errors: [{ message: 'Username not found' }] }).status(200);
            }
            res.json(user).status(200);
        });
    });

    return router;
};