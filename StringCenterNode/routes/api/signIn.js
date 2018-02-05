var express = require('express');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO
     */
    router.post('/', function(req, res, next) {
        res.json({ message: 'TODO' });
    });

    return router;
};
