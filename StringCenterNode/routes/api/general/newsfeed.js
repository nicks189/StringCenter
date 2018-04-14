var express = require('express');
var Post = require('../../../models/post.js');
var UserFollows = require('../../../models/userFollows.js');


function newsfeed(passport){
    var router = express.Router();

    router.get('/', passport.authenticate('jwt', { session: false }), function(req, res, next){
        UserFollows.find({"username" : req.user.username}, function(err, follows){
            if(err){
                return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
            }

            var followsPosts = [];

            follows.forEach(function(f, i){
                Post.find({"authorUsername" : f.followsUsername}, function(err, fPosts){
                    fPosts.forEach(function(fp){
                        followsPosts.push(fp);
                    });


                    followsPosts.sort(function (a, b) {
                        return new Date(b.dateCreated) - new Date(a.dateCreated);
                    });

                    if(i == follows.length - 1){
                        return (followsPosts.length > 0 ? res.json({posts: followsPosts}).status(200) : res.json({errors: [{message: 'Newsfeed empty'}]}));
                    }
                });
            });
        });
    });
    return router;
}


module.exports = newsfeed;
