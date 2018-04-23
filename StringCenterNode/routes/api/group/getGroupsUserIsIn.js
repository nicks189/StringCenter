var express = require('express');
var UserGroup = require('../../../models/userGroup');

function getGroupsUserIsIn(passport){
    var router = express.Router();
    router.get('/:username?', passport.authenticate('jwt', { session: false }), function(req, res, next){
        var username = req.params.username ? req.params.username : req.user.username;
        UserGroup.find({'username' : username}, function(err, ug){
            if (err) return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            let groupNames = [];
            ug.forEach(function(e){groupNames.push(e.groupName);});
            groupNames = groupNames.sort(function(a, b){return a.toLowerCase().localeCompare(b.toLowerCase());});
            return res.json({ groupsByName: groupNames }).status(200);
        });
    });
    return router;
}


module.exports = getGroupsUserIsIn;   
