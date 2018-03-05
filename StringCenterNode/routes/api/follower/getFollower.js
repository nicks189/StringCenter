const express = require('express');
const UserFollows = require('../../../models/userFollows');

module.exports = function(passport) {
    let router = express.Router();

    /*
     * --- Get all users the currently authenticated user follows ---
     */
    router.get('/following', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ username: req.user.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'Not following anyone' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let following = [];
            userFollows.forEach(function(e) {
                 following.push(e.followsUsername);
            });
            res.json({ following: following }).status(200);
        });
    });

    /*
     * --- Get all users that the user specified by username follows ---
     */
    router.get('/following/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ username: req.params.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'Not following anyone' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let following = [];
            userFollows.forEach(function(e) {
                 following.push(e.followsUsername);
            });
            res.json({ following: following }).status(200);
        });
    });

    /*
     * --- Get followers of the currently authenticated user ---
     */
    router.get('/followers', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ followsUsername: req.user.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'No followers' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let followers = [];
            userFollows.forEach(function(e) {
                 followers.push(e.username);
            });
            res.json({ followers: followers }).status(200);
        });
    });

    /*
     * --- Get followers of the user specified by username ---
     */
    router.get('/followers/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ followsUsername: req.params.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'No followers' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let followers = [];
            userFollows.forEach(function(e) {
                 followers.push(e.username);
            });
            res.json({ followers: followers }).status(200);
        });
    });

    return router;
};