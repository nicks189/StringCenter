const express = require('express');
const user = require('../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    /* GET users listing. */
    router.get('/', function(req, res, next) {
        res.render('general/about', {title: 'About', nav: 'about'});
    });

    return router;
};