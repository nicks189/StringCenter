var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO
     */
    router.post('/:username', function(req, res, next) {
        console.log(req.body);
        User.findOne({ 'username': req.params.username }, function (error, user) {
            if (error) {
                res.json({ error: 'Something went wrong' }).status(500);
            } else if (!user) {
                res.json({ error: 'Username not found'}).status(400);
            }
            console.log(user);
            if (typeof req.body.newUsername != 'undefined') {
                user.username = req.body.newUsername;
            }
            if (typeof req.body.newFirstName != 'undefined') {
                user.firstName = req.body.newFirstName;
            }
            if (typeof req.body.newLastName != 'undefined') {
                user.lastName = req.body.newLastName;
            }
            if (typeof req.body.newPassword != 'undefined') {
                user.password = req.body.newPassword;
            }
            User.findOneAndUpdate({ 'username': req.params.username}, {$set: { name: user.username,
                                     firstName: user.firstName, lastName: user.lastName,
                                     password: user.password }}, function(error, user) {
                if (error) {
                    return res.json({ error: 'Username is already taken' }).status(400);
                }
                console.log(user);
                res.json({ message: 'Update successful' }).status(200);
            });
        });
    });

    return router;
};