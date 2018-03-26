var express = require('express');
var Group = require('../../../models/group');

module.exports = function(passport){
    var router = express.Router();

    //gets all groups alphabetically by name
    //authentication removed for testing
    router.get('/:groupName', function(req, res, next){
        if(req.params.groupName){
            Group.findOne({groupName : req.params.groupName}, function(err, group){
                if (err) {
                  return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }

                res.json({ group: group }).status(200);
            });
        }
    });
    return router;
}
