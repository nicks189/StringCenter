var express = require('express');
var UserFollows = require('../../../models/userFollows');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * --- Get followers of the currently authenticated user ---
     */
    router.get('/following', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ 'username': req.user.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'Not following anyone' }] }).status(400);
            }
            let following = [];
            userFollows.forEach(function(e) {
                 following.push(e.followsUsername);
            });
            res.json({ following: following }).status(200);
        });
    });

    /*
     * --- Get all users the currently authenticated user follows ---
     */
    router.get('/followers', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ 'followsUsername': req.user.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'No followers' }] }).status(400);
            }
            let followers = [];
            userFollows.forEach(function(e) {
                 followers.push(e.username);
            });
            res.json({ followers: followers }).status(200);
        });
    });

    return router;
};