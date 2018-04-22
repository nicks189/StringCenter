var express = require('express');
var Post = require('../../../models/post.js');
var UserFollows = require('../../../models/userFollows.js');
var UserGroup = require('../../../models/userGroup.js');


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
        UserFollows.find({"username" : req.user.username}, function(uferr, follows){
            if (uferr) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
            var followsPosts = [];
            follows.forEach(function(f, i){
                Post.find({"authorUsername" : f.followsUsername}, function(perr, fPosts){
                    if (perr) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                    fPosts.forEach(function(fp){followsPosts.push(fp);});
                    if (i == follows.length - 1){
                        UserGroup.find({"username" : req.user.username}, function(ugerr, ug){
                            if (ugerr) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                            ug.forEach(function(ugs, j){
                                Post.find({"groupName" : ugs.groupName}, function(pugerr, gPosts){
                                    if (pugerr) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                                    gPosts.forEach(function(gp){followsPosts.push(gp);});
                                    if(j == ug.length - 1){
                                        let uniqueIDs = [];
                                        let uniquePosts = [];
                                        followsPosts.forEach(function(fp){
                                            if(uniqueIDs.indexOf(String(fp._id)) == -1){
                                                uniqueIDs.push(String(fp._id));
                                                uniquePosts.push(fp);
                                            }
                                        });

                                        Post.buildPostList(uniquePosts, function (error, ret) {
                                            if (error) return res.json({errors: [{message: 'Something went wrong building the post list'}]}).status(500);
                                            return res.json({posts : ret}).status(200);
                                        });
                                    }
                                });
                            });
                        });
                    }
                });
            });
        });
    });
    return router;
}


module.exports = newsfeed;
