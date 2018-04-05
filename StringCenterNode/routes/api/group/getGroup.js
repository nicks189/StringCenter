var express = require('express');
var Group = require('../../../models/group');

module.exports = function(passport){
    var router = express.Router();
    //authentication removed for testing
    /**
     * Get Group record by groupName
     * @param  {HttpRequest}   req  url: 3000/api/get-group/:groupName
     * @param  {HttpResponse}        res
     * @param  {Function} next [description]
     * @return {Group}        returns Group record with matching groupName given in the request, else {
     *                        else it will return a message saying the Group does not exist. 
     */
    router.get('/:groupName', function(req, res, next){
        if(req.params.groupName){
            Group.findOne({groupName : req.params.groupName}, function(err, group){
                if (err) {
                  return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }

                return (group ? res.json({ group: group }).status(200) : res.json({errors: [{message : 'Group does not exist'}]}));
            });
        }
    });
    return router;
}
