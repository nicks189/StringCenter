var express = require('express');
var UserGroup = require('../../../models/userGroup');

module.exports = function(passport){
    var router = express.Router();
    //routes

    //TODO if admin leaves make oldest user admin
    //deletes userGroup record with given parameters,
    //authentication removed for testing
    router.post('/', function(req, res, next){
        if(req.body.username && req.body.groupName){
            UserGroup.findOne({"username": req.body.username, "groupName": req.body.groupName}, function(findErr, userGroup){
                if (findErr) {
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                } else if(!userGroup) {
                    console.log(userGroup);
                    return res.json({errors: [{message: 'This user is not in this group'}]}).status(500);
                } else if(userGroup){
                    console.log(userGroup);
                    userGroup.remove(function(removeErr){
                        if (removeErr) {
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
