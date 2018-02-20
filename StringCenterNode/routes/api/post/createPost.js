var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO -- Add groupName and tabId
     */
    router.post('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        if (req.body.title && req.body.content) {
            var newPost = new Post();
            newPost.title = req.body.title;
            newPost.content = req.body.content;
            // newPost.groupName = req.body.groupName;
            // newPost.tabId = req.body.tabId;
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