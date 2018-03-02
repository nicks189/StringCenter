var express = require('express');
var Group = require('../../../models/group');

module.exports = function(passport){
    var router = express.Router();

    router.get('/', function(req, res, next){
        Group.find(function(err, groups){
            if (err) {
              return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }

            let groupNames = [];
            groups.forEach(function(e){
                groupNames.push(e.groupName);
            });

            //sort usernames alphabetically
            groupNames = groupNames.sort(function(a, b){
                return a.toLowerCase().localeCompare(b.toLowerCase());
            });
            res.json({ groupsByName: groupNames }).status(200);
        });

    });



    return router;
}
