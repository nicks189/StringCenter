const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../../../models/user')
const config = require('../../../config/config')

/**
 * Generate and send JWT in response used for authentication
 * Body:
 *       username
 *       password
 * @param  {HttpRequest}   req  url: /api/sign-in/
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {String}        JSON Web Token
 */
module.exports = function(passport) {
    let router = express.Router();

    router.post('/', function(req, res, next) {
        if (req.body.username && req.body.password) {
            User.findOne({ username: req.body.username }, function(error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }
                if (user && User.comparePasswords(req.body.password, user.password)) {
                    // username and password match
                    let token = jwt.sign(user.id, config.session.key);
                    return res.json({ message: 'Sign in succesful', token: token }).status(200);
                }
                // username or password were wrong, we don't tell the client which one
                return res.json({ errors: [{ message: 'Invalid username or password' }] }).status(400);
            });
        } else {
            res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};
