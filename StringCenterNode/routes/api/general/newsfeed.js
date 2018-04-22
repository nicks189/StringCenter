var express = require('express');
var Post = require('../../../models/post.js');
var UserFollows = require('../../../models/userFollows.js');


/**
* Returns posts from all of the users the user follows, sorted by time newest to oldest
* @param  {Passport}      passport Authentication
* @param  {HttpRequest}   req  url: /api/newsfeed
* @param  {HttpResponse}  res
* @param  {Function}      next
* @return {Post}                array of posts
 */
function newsfeed(passport){
    var router = express.Router();
    router.get('/', passport.authenticate('jwt', { session: false }), function(req, res, next){
        UserFollows.find({"username" : req.user.username}, function(err, follows){
            if (err) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);

            var followsPosts = [];
            follows.forEach(function(f, i){
                Post.find({"authorUsername" : f.followsUsername}, function(err, fPosts){
                    fPosts.forEach(function(fp){followsPosts.push(fp);});
                    if (i == follows.length - 1){
                        followsPosts.sort(function(a, b){return new Date(b.dateCreated) - new Date(a.dateCreated);});
                        return (followsPosts.length > 0 ? res.json({posts: followsPosts}).status(200) : res.json({errors: [{message: 'Newsfeed empty'}]}).status(201));
                    }
                });
            });
        });
    });
    return router;
}


module.exports = newsfeed;
