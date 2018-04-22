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
                //console.log(posts);
                if (posts.length == 0) return res.json("No posts");
                posts.forEach(function(p, i){
                    if(p.tabId){
                        Tab.findOne({"_id" : p.tabId}, function(err, tab){
                            if (err) return res.json({ errors: [{ message: 'Something went wrong in finding a tab' }] }).status(500);
                            console.log(tab);

                            if(tab){
                                p.tab = tab;
                                if(i == posts.length - 1){
                                    posts.sort(function(a, b){return new Date(b.dateCreated) - new Date(a.dateCreated);});
                                    return res.json({posts : posts}).status(200);
                                }
                            }
                        });
                    } else if(i == posts.length - 1){
                        posts.sort(function(a, b){return new Date(b.dateCreated) - new Date(a.dateCreated);});
                        return res.json({posts : posts}).status(200);
                    }
                });
            });
        }
    });
    return router;
}


module.exports = getGroupPosts;
