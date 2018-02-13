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
                return res.json({ error: 'Something went wrong' }).status(500);
            } else if (users.length === 0) {
                return res.json({error: 'No users found'}).status(400);
            }
            res.json({ users: users }.status(200));
        });
    });

    /*
     * TODO: add authentication
     */
    router.get('/:username', function(req, res, next) {
        User.findOne({ 'username': req.params.username}, function(error, user) {
            if (error) {
                return res.json({ error: 'Something went wrong' }).status(500);
            } else if (!user) {
                return res.json({error: 'Username not found'}).status(400);
            }
            res.json(user).status(200);
        });
    });

    return router;
};