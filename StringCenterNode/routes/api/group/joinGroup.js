var express = require('express');
var UserGroup = require('../../../models/userGroup');


module.exports = function(passport){
    var router = express.Router();

    //request from user to join a group based on groupName, only required body field once authentication
    //is implemented is groupName. As of now validation has been removed for easy testing
    router.post('/', function(req, res, next){
        if(req.body.groupName){
            console.log(req.body);

            UserGroup.findOne({"username": req.body.username, "groupName" : req.body.groupName}, function(error, userGroup){
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (userGroup) {
                    return res.json({ errors: [{ message: 'User is already in the requested group' }] }).status(400);
                } else{

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
                }
            });
        } else {
                return res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });
    return router;
}
