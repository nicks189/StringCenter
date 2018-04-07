var express = require('express');
var Group = require('../../../models/group');
var UserGroup = require('../../../models/userGroup');


/**
 * Create group record in DB based on groupName and description given in the request.
 * Note: the user who created the group will be the groups admin, thus putting the user
 * into the group (creating a UserGroup record)
 * @param  {passport}           passport  used for authentication
 * @param  {HttpPostRequest}    req       url: /api/create-group (body must contain 'groupName', and optionally a 'description')
 * @param  {HttpResponse}       res
 * @param  {Function}           next
 * @return {Group}                    returns created group record
 */
function createGroup(passport){
    var router = express.Router();

    router.post('/', function(req, res, next) {
        if(req.body.groupName && req.body.description && req.body.username){
            //checks if group already exists, if it does, it will respond with an error, if not
            //it will create the group
            Group.findOne({'groupName' : req.body.groupName}, function (err, group) {
                if (err) {
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                } else if(group) {
                    console.log(group);
                    return res.json({errors: [{message: 'This Group already exists, try a different name'}]}).status(500);
                } else{
                    //create group record
                    var newGroup = new Group();
                    newGroup.groupName = req.body.groupName;
                    newGroup.description = req.body.description;

                    //create usergroup record
                    var newUserGroup = new UserGroup();
                    newUserGroup.username = req.body.username;
                    newUserGroup.groupName = req.body.groupName;
                    newUserGroup.admin = true;

                    newGroup.validateAndSave(function(errors, group){
                        if(errors){
                            return res.json(errors).status(400);
                        } else{
                            newUserGroup.validateAndSave(function(errors, userGroup){
                                if(errors){
                                    return res.json(errors).status(400);
                                } else{
                                    res.json({group: group, userGroup: userGroup}).status(201);
                                }
                            });
                        }
                    });




                }
            });
        } else{
            return res.json({errors: [{message: 'Invalid Request'}] }).status(400);
        }
    });

    return router;
}


module.exports = createGroup;
