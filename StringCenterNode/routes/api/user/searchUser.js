const express = require('express');
const User = require('../../../models/user');

// TODO -- Order results based on relevancy
/**
 * Search for users based on parameter 'query'
 * @param  {HttpRequest}   req  url: /api/search-user/:query
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {User}          List of users
 */
module.exports = function(passport) {
    let router = express.Router();

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