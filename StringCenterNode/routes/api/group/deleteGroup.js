var express = require('express');
var UserGroup = require('../../../models/userGroup');
var Group = require('../../../models/group');
var Post = require('../../../models/post')

module.exports = function(passport){
    var router = express.Router();
    //routes


    //authentication removed for testing

    /**
     * Deletes group if user who requested delete is a group admin.
     * Deletes all records associated with the group, UserGroup, Post and the Group record itself
     * @param  {HttpRequest}    req  url: 3000/api/delete-group (body must contain 'groupName' of Group to be deleted)
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {UserGroup}           UserGroup record of user who deleted group
     */
    router.post('/', function(req, res, next){
        if(req.body.groupName && req.body.username){
            UserGroup.findOne({"username" : req.body.username, "groupName" : req.body.groupName}, function(findErr, userGroup){
                if (findErr) {
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                } else if(!userGroup) {
                    console.log(userGroup);
                    return res.json({errors: [{message: 'This user is not in this group'}]}).status(500);
                } else if(userGroup && !userGroup.admin){
                    return res.json({errors: [{message: 'User is not an admin'}]}).status(500);
                } else if(userGroup && userGroup.admin){
                    Group.remove({"groupName" : userGroup.groupName}, function(groupRemoveErr){
                        if(groupRemoveErr){
                            return res.json({errors: [{message: 'Something went wrong in removal of group'}]}).status(500);
                        } else{
                            UserGroup.remove({"groupName" : userGroup.groupName}, function(userGroupRemoveErr, removed){
                                if(userGroupRemoveErr){
                                    return res.json({errors: [{message: 'Something went wrong in removal of userGroup'}]}).status(500);
                                } else {
                                    Post.remove({"groupName" : userGroup.groupName}, function(postRemoveErr){
                                        if(postRemoveErr){
                                            return res.json({errors: [{message: 'Something went wrong in removal of posts'}]}).status(500);
                                        } else{
                                            return res.json({userGroup : userGroup});
                                        }
                                    });
                                }
                            })
                        }
                    });
                }
            });
        } else{
            return res.send("Error in request");
        }
    });

    return router;
}
