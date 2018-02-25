var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport) {
    var router = express.Router();

    /*
     * TODO: Update authorization so admins/mods can delete posts
     */
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