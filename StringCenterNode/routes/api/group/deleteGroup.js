var express = require('express');
var UserGroup = require('../../../models/userGroup');
var Group = require('../../../models/group');
var Post = require('../../../models/post')


/**
 * Deletes group if user who requested delete is a group admin.
 * Deletes all records associated with the group, UserGroup, Post and the Group record itself
 * @param  {passport}       passport  used for authentication
 * @param  {HttpRequest}    req  url: /api/delete-group (body : 'groupName')
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {UserGroup}           UserGroup record of user who deleted group
 */
function deleteGroup(passport){
    var router = express.Router();
    router.delete('/:groupName', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.params.groupName && req.user.username){
            UserGroup.findOne({"username" : req.user.username, "groupName" : req.params.groupName}, function(findErr, userGroup){
                if (findErr) {
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                } else if(!userGroup) {
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
                                        return (postRemoveErr ? res.json({errors: [{message: 'Something went wrong in removal of posts'}]}).status(500) : res.json({userGroup : userGroup}));
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


module.exports = deleteGroup;
