var express = require('express');
var UserGroup = require('../../../models/userGroup');
var Group = require('../../../models/group');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //todo
    //authentication removed for testing
    router.post('/', function(res, req, next){
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
                    Group.remove({"groupName" : userGroup.groupName}, function(removeErr){
                        if(removeErr){
                            return res.json({errors: [{message: 'Something went wrong in removal'}]}).status(500);
                        } else{
                            return res.json(userGroup);
                        }
                    });
                }
            });
        }
    });

    return router;
}
