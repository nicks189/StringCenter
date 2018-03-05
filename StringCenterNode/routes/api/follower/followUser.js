const express = require('express');
const UserFollows = require('../../../models/userFollows');
const User = require('../../../models/user');

module.exports = function(passport){
    let router = express.Router();

    router.post('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if (req.user.username === req.params.username) {
            return res.json({ errors: [{ message: 'Cannot follow yourself' }] }).status(400);
        }
        UserFollows.findOne({ username: req.user.username,
            followsUsername: req.params.username }, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows) {
                return res.json({ errors: [{ message: 'Already following user' }] }).status(400);
            }
            let newUserFollows = new UserFollows();
            newUserFollows.username = req.user.username;
            newUserFollows.followsUsername = req.params.username;
            newUserFollows.validateAndSave(function(err, saved) {
                if (err) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }
                res.json(saved).status(201);
            });
        });
    });
    return router;
};
