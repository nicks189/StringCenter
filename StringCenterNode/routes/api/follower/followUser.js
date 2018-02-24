var express = require('express');
var UserFollows = require('../../../models/userFollows');
var User = require('../../../models/user');

module.exports = function(passport){
    var router = express.Router();

    router.post('/', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if (req.body.followsUsername) {
            UserFollows.findOne({ 'username': req.user.username,
                'followsUsername': req.body.followsUsername }, function(error, userFollows) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (userFollows) {
                    return res.json({ errors: [{ message: 'Already following user' }] }).status(400);
                }
                let newUserFollows = new UserFollows();
                newUserFollows.username = req.user.username;
                newUserFollows.followsUsername = req.body.followsUsername;
                newUserFollows.validateAndSave(function(err, saved) {
                    if (err) {
                        return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                    }
                    res.json(saved).status(201);
                });
            });
        } else {
            return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });
    return router;
};
