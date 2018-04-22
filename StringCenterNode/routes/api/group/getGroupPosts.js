var express = require('express');
var Post = require('../../../models/post');
var Tab = require('../../../models/tabModel');

/**
 * Returns all posts tied with the requested groupName ordered by timestamp
 * @param  {passport}       passport  used for authentication
 * @param  {HttpGetRequest}    req  url: /api/get-group-posts/:groupName
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Post}                returns an array of Post objects tied with the given Group
 */
function getGroupPosts(passport){
    var router = express.Router();
    router.get('/:groupName', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.params.groupName){
            Post.find({"groupName" : req.params.groupName}, function(error, posts){
                if (error) return res.json({ errors: [{ message: 'Something went wrong in finding a post' }] }).status(500);
                if (posts.length == 0) return res.json("No posts");
                Post.buildPostList(posts, function (error, ret) {
                    if (error) return res.json({errors: [{message: 'Something went wrong building the post list'}]}).status(500);
                    return res.json({posts : ret}).status(200);
                });
            });
        }
    });
    return router;
}


module.exports = getGroupPosts;
