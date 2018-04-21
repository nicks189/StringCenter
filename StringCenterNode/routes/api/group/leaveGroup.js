var express = require('express');
var UserGroup = require('../../../models/userGroup');
var Post = require('../../../models/post');
var Group = require('../../../models/group');

/**
 * Removes UserGroup record matching the username who has requested to leave the Group, in turn
 * removing them from the Group. If the user who has left the group is an admin, the user who has
 * been in the Group the longest will become the new admin. If the user who left the group is the last member
 * of the Group, the Group, and all it's records (Post, UserGroup), will be deleted as well.
 * @param  {passport}       passport  used for authentication
 * @param  {HttpPostRequest}    req  url: /api/leave-group (body : 'groupName')
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {UserGroup}           returns UserGroup record of the user who left the Group
 */
function leaveGroup(passport){
    var router = express.Router();
    router.delete('/:groupName', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.user.username && req.params.groupName){
            UserGroup.findOne({"username": req.user.username, "groupName": req.params.groupName}, function(findErr, userGroup){
                if (findErr) return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);

                if(!userGroup) {
                    return res.json({errors: [{message: 'This user is not in this group'}]}).status(500);
                } else if(userGroup){
                    userGroup.remove(function(removeErr){
                        if (removeErr) return res.json({errors: [{message: 'Something went wrong in removal'}]}).status(500);

                        UserGroup.find({"groupName": req.params.groupName}, function(error, usersStillInGroup){
                            usersStillInGroup = usersStillInGroup.sort(function(a, b){
                                return new Date(b.timestamp) - new Date(a.timestamp);
                            });

                            //if there are still users in group
                            if(userGroup.admin && usersStillInGroup.length > 1 && !usersStillInGroup[1].admin){
                                usersStillInGroup[1].admin = true;
                                usersStillInGroup[1].validateAndSave(function(errors, userGroup){
                                    if (errors) return res.json({errors: [{message: 'Something went wrong updating the userGroup record'}]}).status(400);
                                });

                            //only user left is one leaving
                            } else if(usersStillInGroup <= 1){
                                //No more users in group, delete group and all posts associated
                                Group.remove({"groupName" : userGroup.groupName}, function(groupRemoveErr){
                                    if(groupRemoveErr){
                                        return res.json({errors: [{message: 'Something went wrong in removal of group'}]}).status(500);
                                    } else{
                                        Post.remove({"groupName" : userGroup.groupName}, function(postRemoveErr){
                                            return (postRemoveErr ? res.json({errors: [{message: 'Something went wrong in removal of posts'}]}).status(500) : res.json({userGroup : userGroup}));
                                        });
                                    }
                                });
                            } else{
                                return res.json({userGroup : userGroup});
                            }
                        });
                    });
                }
            });
        } else{
            return res.json({errors: [{message: 'Invalid params'}]}).status(400);
        }
    });

    return router;
}

module.exports = leaveGroup;
