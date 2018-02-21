var express = require('express');
var Group = require('../../../models/group');


module.exports = function(passport){
    var router = express.Router();

    //req.body.groupName is the only thing that will be sent in the body of the request
    //authentication has been removed for testing
    router.post('/', function(req, res, next) {
        if(req.body.groupName){
            //checks if group already exists, if it does, it will respond with an error, if not
            //it will create the group
            Group.findOne({'groupName' : req.body.groupName}, function (err, group) {
                if (err) {
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                } else if(group) {
                    console.log(group);
                    return res.json({errors: [{message: 'This Group already exists, try a different name'}]}).status(500);
                } else{
                    var newGroup = new Group();
                    newGroup.groupName = req.body.groupName;
                    newGroup.validateAndSave(function(errors, group){
                        if(errors){
                            return res.json(errors).status(400);
                        }
                        res.json(group).status(201);
                    });
                }
            });
        } else{
            return res.json({errors: [{message: 'Invalid Request'}] }).status(400);
        }
    });

    return router;
}
