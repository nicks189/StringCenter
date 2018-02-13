var express = require('express');
var User = require('../../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: add authentication
     */
    router.delete('/:username', function(req, res, next) {
        User.findOneAndRemove({ 'username': req.params.username}, function(error, user) {
            if (error) {
                return res.json({ error: 'Something went wrong' }).status(500);
            } else if (!user) {
                return res.json({ error: 'Username not found' }).status(400);
            }
            res.json({ message: 'Successfully deleted user' }).status(200);
        });
    });

    return router;
};