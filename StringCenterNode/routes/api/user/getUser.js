var express = require('express');
var User = require('../../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: add authentication
     */
    router.get('/all', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.find({}, function(error, users) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (users.length === 0) {
                return res.json({ errors: [{ message: 'No users found' }] }).status(400);
            }
            res.json({ users: users }).status(200);
        });
    });

    /*
     * TODO: add authentication
     */
    router.get('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.findOne({ 'username': req.user.username}, function(error, user) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!user) {
                return res.json({ errors: [{ message: 'Username not found' }] }).status(400);
            }
            res.json(user).status(200);
        });
    });

    return router;
};