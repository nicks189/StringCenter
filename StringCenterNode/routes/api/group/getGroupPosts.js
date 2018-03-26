var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //change to make the same as get user posts

    //authentication removed for testing
    //queries posts by groupName and sorts them by timestamp
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
