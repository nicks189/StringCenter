var express = require('express');
var User = require('../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /* GET sign in page. */
    router.get('/', function(req, res, next) {
        // res.status(200).json(User.find());
        User.find(function(error, user) {
            console.log(user);
            res.json(user);
        });
    });

    return router;
};