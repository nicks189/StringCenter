var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //authentication removed for testing
    //queries posts by groupName and sorts them by timestamp
    router.post('/', function(req, res, next){
        if(req.body.groupName){
            Post.find({"groupName" : req.body.groupName}, function(error, posts){
                posts.sort(function(a, b){
                    return new Date(b.timestamp) - new Date(a.timestamp);
                });

                res.json(posts);
            });
        }
    });


    return router;
}
