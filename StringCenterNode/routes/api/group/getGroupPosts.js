var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //authentication removed for testing

    /**
     * Returns all posts tied with the requested groupName ordered by timestamp
     * @param  {HttpRequest}    req  url: 3000/api/get-group-posts/:groupName
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {Post}                returns an array of Post objects tied with the given Group
     */
    router.get('/:groupName', function(req, res, next){
        if(req.params.groupName){
            Post.find({"groupName" : req.params.groupName}, function(error, posts){
                posts.sort(function(a, b){
                    return new Date(b.timestamp) - new Date(a.timestamp);
                });

                res.json({posts: posts}).status(200);
            });
        }
    });

    return router;
}
