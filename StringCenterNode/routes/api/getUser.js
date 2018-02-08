var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: add authentication
     */
    router.get('/', function(req, res, next) {
        User.find({}, function(error, users) {
            if (error) {
                res.json({ error: 'Something went wrong' }).status(500);
            } else if (users.length === 0) {
                res.json({ error: 'No users found'}).status(400);
            } else {
                res.json({ users: users });
            }
        });
    });

    /*
     * TODO: add authentication
     */
    router.get('/:username', function(req, res, next) {
        User.findOne({ 'username': req.params.username}, function(error, user) {
            if (error) {
                res.json({ error: 'Something went wrong' }).status(500);
            } else if (!user) {
                res.json({ error: 'Username not found'}).status(400);
            } else {
                res.json(user);
            }
        });
    });

    return router;
};