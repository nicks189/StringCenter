var express = require('express');
var UserGroup = require('../../../models/userGroup');
var User = require('../../../models/user');
var Group = require('../../../models/group');

//authentication has been removed for testing

/**
 * Adds a UserGroup record to the database based on the given groupName, in turn adding the user
 * to the Group. Returns the created UserGroup record.
 * @param  {passport}       passport  used for authentication
 * @param  {HttpPostRequest}    req       url: /api/join-group (body : 'groupName')
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {UserGroup}                returns UserGroup record that is created when the user joins the group
 */
function joinGroup(passport){
    var router = express.Router();
    router.post('/', function(req, res, next){
        if(req.body.groupName && req.body.username){
            console.log(req.body);

            Group.findOne({"groupName": req.body.groupName}, function(groupError, group){
                if(groupError){
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (!group) {
                    return res.json({ errors: [{ message: 'Group does not exist' }] }).status(400);
                } else{
                    UserGroup.findOne({"username": req.body.username, "groupName" : req.body.groupName}, function(userGroupError, userGroup){
                        if (userGroupError) {
                            return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                        } else if (userGroup) {
                            return res.json({ errors: [{ message: 'User is already in the requested group' }] }).status(400);
                        } else{
                            var newUserGroup = new UserGroup();
                            newUserGroup.username = req.body.username;
                            //when authorization is implemented the above assignment will be
                            //newUserGroup.username = req.user.username;
                            newUserGroup.groupName = req.body.groupName;
                            if(req.body.admin == "true"){
                                newUserGroup.admin = req.body.admin;
                            }
                            newUserGroup.validateAndSave(function(errors, userGroup){
                                return (!errors ? res.json(userGroup).status(201) : res.json(errors).status(400));
                            });
                        }
                    });
                }
            });
        } else {
                return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });
    return router;
}


module.exports = joinGroup;
