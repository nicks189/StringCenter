var express = require('express');
var UserGroup = require('../../../models/userGroup.js');


/**
 * Update user
 * req.params: :username, :groupName, :promotion
 * @param  {Passport}      passport Authentication
 * @param  {HttpRequest}   req  url: /api/promote-user-in-group/:username/:groupName/:promotion
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {String}               promote user to either admin or moderator. Returns "User promoted" if successful
 */
function promoteUser(passport){
    var router = express.Router();
    router.put('/:username/:groupName/:promotion', passport.authenticate('jwt', { session: false }), function(req, res, next){
        if(req.params.username && req.params.groupName && req.params.promotion){
            UserGroup.findOne({"username" : req.user.username, "groupName" : req.params.groupName}, function(err, promoter){
                if(err){return res.json({errors: [{message: 'Something went wroung in checking admin'}]}).status(500);}
                
                if(promoter && (promoter.admin || promoter.moderator)){
                    UserGroup.findOne({"username" : req.params.username, "groupName" : req.params.groupName}, function(err, toPromote){
                        if(err){
                            return res.json({errors: [{message: 'Something went wroung in finding user to promote'}]}).status(500);
                        }

                        var change = false;
                        if(!toPromote){
                            return res.json({errors: [{message: 'User to promote is not a member of the group'}]}).status(400);
                        } else if(req.params.promotion == "moderator" && !toPromote.moderator){
                            toPromote.moderator = true;
                            change = true;
                        } else if(promoter.admin && req.params.promotion == "admin" && !toPromote.admin){
                            toPromote.admin = true;
                            change = true;
                        }

                        if(change){
                            toPromote.validateAndSave(function(err, promotedUserGroup){
                                return (err ? res.json({errors: [{message: 'Something went wroung in saving promoted userGroup'}]}).status(500) : res.json("User promoted").status(201));
                            });
                        }
                    });
                } else{
                    return res.json({errors: [{message: 'You are not an admin or moderator of this group so you cannot promote users'}]}).status(400);
                }
            });
        }
    });
    return router;
}


module.exports = promoteUser;
