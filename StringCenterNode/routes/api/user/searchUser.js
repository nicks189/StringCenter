var express = require('express');
var User = require('../../../models/user');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * Search for users based on parameter 'query'; looks at username, firstName, and lastName
     * TODO -- Order results based on relevancy
     */
    router.get('/:query', function(req, res, next) {
        // search by regular expression of 'query', 'i' flag ignores case
        let regexp = new RegExp(req.params.query, 'i');
        console.log(regexp);
        User.find({
            $or: [
                { username: regexp },
                { firstName: regexp },
                { lastName: regexp }
            ]
        }, { password: 0}, function(error, users) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (users.length === 0) {
                return res.json({ errors: [{ message: 'No users found' }] }).status(200);
            }
            // sort users alphabetically
            users.sort(function(a, b){
                return a.username.toLowerCase().localeCompare(b.username.toLowerCase());
            });
            res.json({ users: users }).status(200);
        });
    });

    return router;
};