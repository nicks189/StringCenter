var express = require('express');
var UserGroup = require('../../../models/group');


module.exports = function(passport){
    var router = express.Router();
    
    //request from user to join a group based on groupName, only required body field once authentication
    //is implemented is groupName. As of now validation has been removed for easy testing
    router.post('/', function(req, res, next){
        if(req.body.groupName){
            var newUserGroup = new UserGroup();
            newUserGroup.username = req.body.username;
            //when authorization is implemented the above assignment will be
            //newUserGroup.username = req.user.username;
            newUserGroup.groupName = req.body.groupName;

            newUserGroup.validateAndSave(function(errors, userGroup){
                if(errors){
                    return res.json(errors).status(400);
                }
                res.json(userGroup).status(201);
            });
        } else {
                return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });
    return router;
}
