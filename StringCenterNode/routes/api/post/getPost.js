const express = require('express');
const Post = require('../../../models/post');

module.exports = function(passport) {
    let router = express.Router();

    /*
     * --- Get posts for the currently authenticated user ---
     */
    router.get('/by-user', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        Post.find({ authorUsername: req.user.username}, function(error, posts) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (posts.length === 0) {
                return res.json({ errors: [{ message: 'No posts found' }] }).status(400);
            }
            posts.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            res.json({ posts: posts }).status(200);
        });
    });

    router.get('/by-user/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        Post.find({ authorUsername: req.params.username}, function(error, posts) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (posts.length === 0) {
                return res.json({ errors: [{ message: 'No posts found' }] }).status(400);
            }
            posts.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            res.json({ posts: posts }).status(200);
        });
    });

    router.get('/by-id/:id', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        Post.findById(req.params.id, function(error, post) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!post) {
                return res.json({ errors: [{ message: 'Post not found' }] }).status(400);
            }
            res.json(post).status(200);
        });
    });

    return router;
};