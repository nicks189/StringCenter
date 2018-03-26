const express = require('express');
const User = require('../../../models/user');

module.exports = function(passport) {
    let router = express.Router();

    /*
     * Search for users based on parameter 'query'; looks at username
     * TODO -- Order results based on relevancy
     */
    router.get('/:query', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        // search by regular expression of 'query', 'i' flag ignores case
        let regexp = new RegExp(req.params.query, 'i');
        User.search(regexp, function(error, users) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }
            res.json({ users: users }).status(200);
        });
    });

    return router;
};