const express = require('express');
const Post = require('../../../models/post');
const User = require('../../../models/user');
const Tab = require('../../../models/tabModel');

module.exports = function(passport) {
    let router = express.Router();

    router.post('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        if (req.body.query) {
            // TODO
            return res.json({ message: 'Todo' }).status(200);
        } else {
            return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};