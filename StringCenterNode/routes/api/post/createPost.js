const express = require('express');
const Post = require('../../../models/post');

/**
 * Create post
 * Body:
 *       content
 *       groupName (optional)
 *       tabId     (optional)
 *
 * @param  {Passport}      Authentication
 * @param  {HttpRequest}   req  url: /api/create-post/
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {Post}          Created post
 */
module.exports = function createPost(passport) {
    let router = express.Router();

    router.post('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        if (req.body.content) {
            let newPost = new Post();
            newPost.content = req.body.content;
            newPost.groupName = req.body.groupName;
            newPost.tabId = req.body.tabId;
            newPost.authorUsername = req.user.username;
            newPost.validateAndSave(function (errors, post) {
                if (errors) {
                    return res.json(errors).status(400);
                }
                res.json(post).status(201);
            });
        } else {
            return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });

    return router;
};
