const express = require('express');
const User = require('../../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    router.put('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.findOne({ username: req.user.username}, function(error, user) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!user) {
                return res.json({ errors: [{ message: 'Username not found' }] }).status(200);
            }
            if (req.body.image) {
                user.profilePic.data = req.body.image;
                // TODO
                user.profilePic.contentType = 'image/png';
            }
            User.findOneAndUpdate({ username: req.user.username }, {
                $set: {
                    profilePic: user.profilePic,
                }
            }, function(error, updatedUser) {
                if (error) {
                    return res.json({ errors: [{ message: 'Username is already taken' }] }).status(400);
                }
                // TODO -- updatedUser is still the old user, fix this
                res.json(updatedUser).status(200);
            });
        });
    });

    return router;
};