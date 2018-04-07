const express = require('express');
const User = require('../../../models/user');

// TODO: add authorization so only mods/admins can access this;
// limit this to some max number of users;
/**
 * Get list of all users, ordered alphabetically and omitting passwords.
 * @param  {HttpRequest}   req  url: 3000/api/get-user/all
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {User}
 */
module.exports.getAllUsers = function(passport) {
    let router = express.Router();
    router.get('/', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        User.find({}, {password: 0}, function (error, users) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (users.length === 0) {
                return res.json({errors: [{message: 'No users found'}]}).status(200);
            }
            // sort users alphabetically
            users.sort(function (a, b) {
                return a.username.toLowerCase().localeCompare(b.username.toLowerCase());
            });
            res.json({users: users}).status(200);
        });
    });
    return router;
};

/**
 * Get by username or currently authenticated user if no parameter, omitting password.
 * @param  {HttpRequest}   req  url: 3000/api/get-user/info
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {User}
 */
module.exports.getUserInfo = function(passport) {
    let router = express.Router();
    router.get('/', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        User.findOne({username: req.user.username}, {password: 0}, function (error, user) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (!user) {
                return res.json({errors: [{message: 'Username not found'}]}).status(200);
            }
            res.json(user).status(200);
        });
    });

    router.get('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        User.findOne({ username: req.params.username}, { password: 0 }, function(error, user) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!user) {
                return res.json({ errors: [{ message: 'Username not found' }] }).status(200);
            }
            res.json(user).status(200);
        });
    });
    return router;
};
