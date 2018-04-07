const express = require('express');
const UserFollows = require('../../../models/userFollows');

/**
 * Unfollow user specified by username
 * @param  {HttpRequest}   req  url: /api/unfollow-user/:username
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {String}
 */
module.exports = function(passport) {
    let router = express.Router();

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