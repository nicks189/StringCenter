const express = require('express');
const User = require('../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    /* GET users listing. */
    router.get('/', User.isAuthenticated, function(req, res, next) {
        res.render('demo/edit-account', { title: 'Edit Account', nav: 'edit-account' });
    });

    return router;
};
