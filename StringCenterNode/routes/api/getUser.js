var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: add authentication
     */
    router.get('/:username', function(req, res, next) {
        User.findOne({ 'username': req.params.username}, function(error, user) {
            if (error) {
                res.json({ error: 'Sign in failed' }).status(500);
            } else if (!user) {
                res.json({ error: 'Username not found'}).status(400);
            } else {
                console.log(user);
                res.json(user);
            }
        });
    });

    return router;
};