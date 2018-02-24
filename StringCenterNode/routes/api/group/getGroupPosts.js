var express = require('express');
var Post = require('../../../models/post');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //authentication removed for testing
    //queries posts by groupName
    router.post('/', function(req, res, next){
        if(req.body.groupName){
            Post.find({"groupName" : req.body.groupName}).sort({"timestamp" : 'ascending'}).exec(function(error, post){
                res.json(post);
            });
        }
    });


    return router;
}
