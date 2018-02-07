var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO
     */
    router.post('/:username', function(req, res, next) {
        if (req.body.password) {
            User.findOne({'username': req.params.username}, function (error, user) {
                console.log(user);
            });
        } else {
            return res.json({ error: 'Invalid request' }).status(400);
        }
    });

    return router;
};