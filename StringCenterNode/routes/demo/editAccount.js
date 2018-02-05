var express = require('express');
var User = require('../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /* GET users listing. */
    router.get('/', User.isAuthenticated, function(req, res, next) {
        res.render('edit-account', { title: 'Edit Account', nav: 'edit-account' });
    });

    return router;
};
