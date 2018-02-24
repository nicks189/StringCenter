var express = require('express');
var UserGroup = require('../../../models/userGroup');


module.exports = function(passport){
    var router = express.Router();

    //queries by requested groupName and returns all usernames in that group
    //authentication removed for testing
    router.post('/', function(req, res, next){
        if(req.body.groupName){
            UserGroup.find({"groupName": req.body.groupName}, function(error, userGroup){
                let usernames = [];
                userGroup.forEach(function(e){
                    usernames.push(e.username);
                });

                //sort usernames alphabetically
                usernames = usernames.sort(function(a, b){
                    return a.toLowerCase().localeCompare(b.toLowerCase());
                });

                res.json({users : usernames});
            });
        }
    })

    return router;
}
