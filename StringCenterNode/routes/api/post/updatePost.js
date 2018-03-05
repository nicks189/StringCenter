const express = require('express');
const Post = require('../../../models/post');

module.exports = function(passport) {
    let router = express.Router();

    router.put('/:id', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        Post.findById(req.params.id, function(error, post) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!post) {
                return res.json({ errors: [{ message: 'Post id not found' }] }).status(400);
            } else if (post.authorUsername !== req.user.username) {
                // Only the original author can edit a post
                return res.json({ errors: [{ message: 'Unauthorized' }] }).status(400);
            }
            if (typeof req.body.title !== 'undefined') {
                post.title = req.body.title;
            }
            if (typeof req.body.content !== 'undefined') {
                post.content = req.body.content;
            }
            if (typeof req.body.tabId !== 'undefined') {
                post.tabId = req.body.tabId;
            }
            if (typeof req.body.groupName !== 'undefined') {
                post.groupName = req.body.groupName;
            }
            post.validateAndSave(function(errors, updatedPost) {
                if (errors) {
                    return res.json(errors).status(400);
                }
                res.json(updatedPost).status(200);
            });
        });
    });

    return router;
};