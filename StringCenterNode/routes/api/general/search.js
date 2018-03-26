const express = require('express');
const Post = require('../../../models/post');
const User = require('../../../models/user');
const Tab = require('../../../models/tabModel');
const Group = require('../../../models/group');

module.exports = function(passport) {
    let router = express.Router();

    // TODO: order by relevancy (in models)
    router.get('/:query', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        // search by regular expression of 'query', 'i' flag ignores case
        let regex = new RegExp(req.params.query, 'i');
        User.search(regex, function(error, users) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }
            Group.search(regex, function(error, groups) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }
                Post.search(regex, function(error, posts) {
                    if (error) {
                        return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                    }
                    Tab.search(regex, function(error, tabs) {
                        if (error) {
                            return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                        }
                        res.json({ users: users, groups: groups, posts: posts, tabs: tabs }).status(200);
                    });
                });
            });
        });
    });

    return router;
};