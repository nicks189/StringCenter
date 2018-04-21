var express = require('express');
var Post = require('../../../models/post');


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
                posts.sort(function(a, b){return new Date(b.timestamp) - new Date(a.timestamp);});
                res.json({posts: posts}).status(200);
            });
        }
    });
    return router;
}


module.exports = getGroupPosts;
