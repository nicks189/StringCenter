var express = require('express');
var Group = require('../../../models/group');


module.exports = function(passport){
    var router = express.Router();

    //req.body.groupName is the only thing that will be sent in the body of the request
    router.post('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        if(req.body.groupName){
            var newGroup = new Group();
            newGroup.groupName = req.body.groupName;
            newGroup.validateAndSave(function(errors, group){
                if(errors){
                    return res.json(errors).status(400);
                }
                res.json(group).status(201);
            });
        } else{
            return res.json({errors: [{message: 'Invalid Request'}] }).status(400);
        }
    });

    return router;
}
