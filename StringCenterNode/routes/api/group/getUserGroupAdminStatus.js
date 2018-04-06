var express = require('express');
var UserGroup = require('../../../models/userGroup');


module.exports = function(passport){
    var router = express.Router();
    //routes
    /**
     * Returns a boolean value representing whether or not a given user is an admin
     * in the given group
     * @param  {HttpRequest}    req  url: 3000/api/get-admin-status/:username/:groupName
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {Boolean}             returns true if user is admin in given group, false otherwise
     */
    router.get('/:username/:groupName', function(req, res, next){
        if(req.params.groupName && req.params.username){
            UserGroup.findOne({'groupName' : req.params.groupName, 'username' : req.params.username}, function(err, userGroup){
                if(err){
                    return res.json({errors: [{message: 'Something went wrong in finding'}]}).status(500);
                } else if(!userGroup){
                    return res.json({errors: [{message : 'User is not a member of this group or the group doesn\'t exist'}]}).status(500);
                } else if(userGroup){
                    return res.json({adminStatus : userGroup.admin});
                } else{
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                }
            });
        }
    });

    return router;
}
