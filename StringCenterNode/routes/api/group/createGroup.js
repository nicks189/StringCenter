var express = require('express');
var Group = require('../../../models/group');
var UserGroup = require('../../../models/userGroup');

module.exports = function(passport){
    var router = express.Router();

    //req.body.groupName is the only thing that will be sent in the body of the request
    //authentication has been removed for testing
    //req.body.username will be replaced  by req.user.username when authentication is put back.
    //when a user creates a group they will automatically be the admin.
    router.post('/', function(req, res, next) {
        if(req.body.groupName && req.body.description && req.body.username){
            //checks if group already exists, if it does, it will respond with an error, if not
            //it will create the group
            Group.findOne({'groupName' : req.body.groupName}, function (err, group) {
                if (err) {
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                } else if(group) {
                    console.log(group);
                    return res.json({errors: [{message: 'This Group already exists, try a different name'}]}).status(500);
                } else{
                    //create group record
                    var newGroup = new Group();
                    newGroup.groupName = req.body.groupName;
                    newGroup.description = req.body.description;

                    //create usergroup record
                    var newUserGroup = new UserGroup();
                    newUserGroup.username = req.body.username;
                    newUserGroup.groupName = req.body.groupName;
                    newUserGroup.admin = true;

                    newGroup.validateAndSave(function(errors, group){
                        if(errors){
                            return res.json(errors).status(400);
                        } else{
                            newUserGroup.validateAndSave(function(errors, userGroup){
                                if(errors){
                                    return res.json(errors).status(400);
                                } else{
                                    res.json({group: group, userGroup: userGroup}).status(201);
                                }
                            });
                        }
                    });




                }
            });
        } else{
            return res.json({errors: [{message: 'Invalid Request'}] }).status(400);
        }
    });

    return router;
}
