const express = require('express');
const User = require('../../../models/user');
const multerOptions = require('../../../middleware/multerOptions');
const upload = require('multer')(multerOptions).single('profilePic');

/**
 * Upload image file and save location as users profile picture
 * Body:
 *       profilePic (file)
 *
 * @param  {Passport}      passport Authentication
 * @param  {HttpRequest}   req  url: /api/set-profile-pic/
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {User}          Updates user
 */
function setPofilePic(passport) {
    let router = express.Router();

    router.put('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        upload(req, res, function(error) {
            if (error) {
               return res.json({ message: error.message }).status(400);
            }
            User.findOne({ username: req.user.username }, function (error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }]}).status(500);
                } else if (!user) {
                    return res.json({ errors: [{ message: 'Username not found' }]}).status(200);
                }
                User.findOneAndUpdate({ username: req.user.username }, {
                    $set: {
                        profilePic: 'uploads/' + req.file.filename,
                    }
                }, { new: true }, function (error, updatedUser) {
                    if (error) {
                        return res.json({ errors: [{ message: 'Something went wrong' }]}).status(500);
                    }
                    res.json(updatedUser).status(200);
                });
            });
        });
    });

    return router;
};

module.exports = setPofilePic;
