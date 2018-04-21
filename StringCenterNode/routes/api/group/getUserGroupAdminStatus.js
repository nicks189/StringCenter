var express = require('express');
var UserGroup = require('../../../models/userGroup');


/**
 * Returns a boolean value representing whether or not a given user is an admin
 * in the given group
 * @param  {passport}       passport  used for authentication
 * @param  {HttpGetRequest}    req  url: /api/get-admin-status/:username/:groupName
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Boolean}             returns true if user is admin in given group, false otherwise
 */
function getUserGroupAdminStatus(passport){
    var router = express.Router();
    router.get('/:username/:groupName', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.params.groupName && req.params.username){
            UserGroup.findOne({'groupName' : req.params.groupName, 'username' : req.params.username}, function(err, userGroup){
                if(err){
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                }
                return (userGroup ? res.json({adminStatus : userGroup.admin}) : res.json({errors: [{message : 'User is not a member of this group or the group doesn\'t exist'}]}).status(500));
            });
        }
    });
    return router;
}


module.exports = getUserGroupAdminStatus;
