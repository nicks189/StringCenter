var express = require('express');
var Group = require('../../../models/group');


//authentication removed for testing
/**
 * Returns all groups in the database, sorted alphabetically by groupName
 * @param  {passport}       passport  used for authentication
 * @param  {HttpRequest}    req  url: 3000/api/get-groups
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {groupName}           returns an alphabetically sorted array of all the groupNames in the database
 */
function getGroups(passport){
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


module.exports =  getGroups;
