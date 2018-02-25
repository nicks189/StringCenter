var express = require('express');
var UserFollows = require('../../../models/userFollows');

module.exports = function(passport) {
    var router = express.Router();

    router.delete('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.findOneAndRemove({ 'username': req.user.username,
            'followsUsername': req.params.username }, function (error, userFollows) {
            console.log(req.user.username);
            console.log(req.params.username);
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!userFollows) {
                return res.json({ errors: [{ message: 'Not following that user' }] }).status(400);
            }
            res.json({ message: 'Successfully unfollowed user' }).status(200);
        });
    });

    return router;
};