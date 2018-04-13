var express = require('express');
var Group = require('../../../models/group.js');
var UserGroup = require('../../../models/userGroup.js');


/**
 *  Update Group record based on specifications in request.
 *  Request must contain:
 *  The Group must exist and the user who requested the change must be an admin of the Group.
 * @param  {passport}           passport authentication (unused for testing)
 * @param  {HttpPostRequest}    req       url: /api/update-group (body: current groupName, new groupName, new description)
 * @param  {HttpResponse}       res
 * @param  {Function}           next
 * @return {Group}                       updated Group record
 */
function updateGroup(passport){
    var router = express.Router();

    router.put('/', function(req, res, next){
        if(req.body.username && req.body.curGroupName && req.body.newGroupName){
            Group.findOne({"groupName" : req.body.curGroupName}, function(err, group){
                if(err){
                    return res.json({errors: [{message: 'Something went wroung'}]}).status(500);
                }

                if(!group){
                    return res.json({errors: [{message: 'The group doesnt exist'}]}).status(500);
                } else if(group && group.groupName == req.body.curGroupName && group.description == req.body.description){
                    return res.json('Unchanged, record is the same');
                }

                if(group) {
                    UserGroup.findOne({"admin" : req.body.username, "groupName" : req.body.curGroupName}, function(err, userGroup){
                        if(userGroup && !userGroup.admin){
                            return res.json({errors: [{message: 'User is not an admin of the Group'}]}).status(500);
                        } else{
                            group.groupName = req.body.newGroupName;
                            if(req.body.description != ""){
                                group.description = req.body.description;
                            }

                            group.validateAndSave(function(errors, newGroup){
                                if(errors){
                                    return res.json(errors).status(400);
                                }

                                if(newGroup.groupName == req.body.curGroupName){
                                    return res.json({newGroup: newGroup, userGroupUpdateCount : 0}).status(201);
                                } else{
                                    UserGroup.find({"groupName" : req.body.curGroupName}, function(er, userGroupsToUpdate){
                                        if(er){
                                            return res.json({errors: [{message: 'error finding other users in the Group'}]}).status(500);
                                        }

                                        if(userGroupsToUpdate){
                                            console.log(userGroupsToUpdate);
                                            userGroupsToUpdate.forEach(function(e){
                                                e.groupName = req.body.newGroupName;
                                                e.validateAndSave(function(saveErr, newUserGroups){
                                                    if(saveErr){
                                                        return res.json({errors: [{message: 'error updating userGroup records'}]});
                                                    }
                                                });
                                            });
                                        }


                                        return res.json({newGroup: newGroup, userGroupUpdateCount : userGroupsToUpdate.length}).status(201);
                                    });
                                }
                            });
                        }
                    });
                }
            });
        } else{
            return res.json({errors: [{message: "Wrong arguments in request body. Format: {username, curGroupName, newGroupName, description}"}]}).status(500);
        }
    });
    return router;
}

module.exports = updateGroup;
