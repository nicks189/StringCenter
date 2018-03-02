var express = require('express');
var UserGroup = require('../../../models/userGroup');

module.exports = function(passport){
    var router = express.Router();
    //routes

    router.post('/', function(req, res, next){
        if(req.body.username && req.body.groupName){
            UserGroup.remove({'username': req.body.username, 'groupName': req.body.groupname}, function(err, userGroup){
                if (err) {
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                } else if(!userGroup) {
                    console.log(userGroup);
                    return res.json({errors: [{message: 'This user is not in this group'}]}).status(500);
                } else if(userGroup){
                    return res.json(userGroup);
                }
            });
        }
    });

    return router;
}
