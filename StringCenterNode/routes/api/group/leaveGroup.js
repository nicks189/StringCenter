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
 * @param  {HttpRequest}    req  url: 3000/api/leave-group (body must contain a 'groupName')
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {UserGroup}           returns UserGroup record of the user who left the Group
 */
function leaveGroup(passport){
    var router = express.Router();
    //routes

    //deletes userGroup record with given parameters,
    //authentication removed for testing
    //TODO: test new conditional
    router.post('/', function(req, res, next){
        if(req.body.username && req.body.groupName){
            //find matching record
            UserGroup.findOne({"username": req.body.username, "groupName": req.body.groupName}, function(findErr, userGroup){
                if (findErr) {
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                } else if(!userGroup) {
                    console.log(userGroup);
                    return res.json({errors: [{message: 'This user is not in this group'}]}).status(500);
                } else if(userGroup){
                    console.log(userGroup);
                    //delete usergroup
                    userGroup.remove(function(removeErr){
                        if (removeErr) {
                            return res.json({errors: [{message: 'Something went wrong in removal'}]}).status(500);
                        } else{

                            //change admin (find userGroup records)
                            UserGroup.find({"groupName": req.body.groupName}, function(error, usersStillInGroup){
                                usersStillInGroup = usersStillInGroup.sort(function(a, b){
                                    return new Date(b.timestamp) - new Date(a.timestamp);
                                });

                                //if there are still users in group
                                if(userGroup.admin && usersStillInGroup.length > 1 && !usersStillInGroup[1].admin){
                                    usersStillInGroup[1].admin = true;
                                    console.log(usersStillInGroup);
                                    usersStillInGroup[1].validateAndSave(function(errors, userGroup){
                                        if(errors){
                                            console.log("updated");
                                            return res.json({errors: [{message: 'Something went wrong updating the userGroup record'}]}).status(400);
                                        }
                                        console.log("updated");
                                        //res.json(userGroup).status(201);
                                    });
                                //only user left is one leaving
                                } else if(usersStillInGroup <= 1){
                                    //No more users in group, delete group and all posts associated
                                    Group.remove({"groupName" : userGroup.groupName}, function(groupRemoveErr){
                                        console.log("groupRemove");
                                        if(groupRemoveErr){
                                            return res.json({errors: [{message: 'Something went wrong in removal of group'}]}).status(500);
                                        } else{
                                            Post.remove({"groupName" : userGroup.groupName}, function(postRemoveErr){
                                                if(postRemoveErr){
                                                    return res.json({errors: [{message: 'Something went wrong in removal of posts'}]}).status(500);
                                                } else{
                                                    return res.json({userGroup : userGroup});
                                                }
                                            });

                                        }
                                    });
                                    //return res.json('Group removed, no more members').status(200);
                                } else{
                                    return res.json({userGroup : userGroup});
                                }
                            });
                        }
                    });
                }
            });
        }
    });

    return router;
}

module.exports = leaveGroup;
