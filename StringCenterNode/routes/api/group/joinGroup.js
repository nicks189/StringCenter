var express = require('express');
var UserGroup = require('../../../models/userGroup');
var User = require('../../../models/user');
var Group = require('../../../models/group');


module.exports = function(passport){
    var router = express.Router();

    //request from user to join a group based on groupName, only required body field once authentication
    //is implemented is groupName. As of now validation has been removed for easy testing
    router.post('/', function(req, res, next){
        if(req.body.groupName){
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
                                if(errors){
                                    return res.json(errors).status(400);
                                }
                                res.json(userGroup).status(201);
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
