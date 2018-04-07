const express = require('express');
const Post = require('../../../models/post');

// TODO: Update authorization so admins/mods can delete posts
/**
 * Delete post by id
 * @param  {HttpRequest}   req  url: /api/delete-post/:id
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {String}        Message
 */
module.exports = function deletePost(passport) {
    let router = express.Router();

    router.delete('/:id', passport.authenticate('jwt', { session: false }), function(req, res, next) {
       Post.validateUserAndRemove(req.params.id, req.user.username, function (error, post) {
           if (error) {
               return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
           } else if (!post) {
               return res.json({ errors: [{ message: 'Post not found' }] }).status(400);
           }
           res.json({ message: 'Successfully deleted post' }).status(200);
       });
    });

    return router;
};