var express = require('express');
var Group = require('../../../models/group');


/**
 * Get Group record by groupName
 * @param  {passport}       passport  used for authentication
 * @param  {HttpGetRequest}    req  url: /api/get-group/:groupName
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Group}        returns Group record with matching groupName given in the request, else {
 *                        else it will return a message saying the Group does not exist.
 */
function getGroup(passport){
    var router = express.Router();
    router.get('/:groupName', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.params.groupName){
            Group.findOne({groupName : req.params.groupName}, function(err, group){
                if (err) return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                return (group ? res.json({ group: group }).status(200) : res.json({errors: [{message : 'Group does not exist'}]}));
            });
        }
    });
    return router;
}


module.exports = getGroup;
