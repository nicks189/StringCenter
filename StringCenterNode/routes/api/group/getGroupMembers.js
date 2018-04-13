var express = require('express');
var UserGroup = require('../../../models/userGroup');


//authentication removed for testing
/**
 * Returns usernames in alphabetical order for members in a Group with the matching groupName.
 * @param  {passport}       passport  used for authentication
 * @param  {HttpGetRequest}    req  url: /api/get-group-members/:groupName
 * @param  {HttpResponse}   res
 * @param  {Function} next
 * @return {Group}        [
 */
 function getGroupMembers(passport){
    var router = express.Router();

    router.get('/:groupName', function(req, res, next){
        if(req.params.groupName){
            UserGroup.find({"groupName": req.params.groupName}, function(error, userGroup){
                let usernames = [];
                userGroup.forEach(function(e){
                    usernames.push(e.username);
                });

                //sort usernames alphabeticallybingbangboom
                usernames = usernames.sort(function(a, b){
                    return a.toLowerCase().localeCompare(b.toLowerCase());
                });

                return (usernames.length > 0 ? res.json({ usernames : usernames }).status(200) : res.json({errors: [{message : 'no one in Group'}]}));
            });
        }
    });

    return router;
}


module.exports = getGroupMembers;
