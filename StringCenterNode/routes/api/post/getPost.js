const express = require('express');
const Post = require('../../../models/post');

/**
 * Get all posts created by username or the currently authenticated user
 * if username isn't passed
 * @param  {HttpRequest}   req  url: /api/get-post/by-user/:username
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {Post}          List of posts
 */
module.exports.getPostsForUser = function getPost(passport) {
    let router = express.Router();

    router.get('/', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        Post.find({authorUsername: req.user.username}, function (error, posts) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (posts.length === 0) {
                return res.json({errors: [{message: 'No posts found'}]}).status(400);
            }
            posts.sort(function (a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            res.json({posts: posts}).status(200);
        });
    });

    router.get('/:username', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        Post.find({authorUsername: req.params.username}, function (error, posts) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (posts.length === 0) {
                return res.json({errors: [{message: 'No posts found'}]}).status(400);
            }
            posts.sort(function (a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            res.json({posts: posts}).status(200);
        });
    });

    return router;
};

/**
 * Get post by id
 * @param  {HttpRequest}   req  url: /api/get-post/by-id/:id
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {Post}
 */
module.exports.getPostById = function(passport) {
    let router = express.Router();

    router.get('/:id', passport.authenticate('jwt', { session: false }), function(req, res, next) {
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