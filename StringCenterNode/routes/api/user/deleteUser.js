const express = require('express');
const User = require('../../../models/user');

/**
 * Get user by username, omitting password.
 * @param  {Passport}      passport Authentication
 * @param  {HttpRequest}   req  url: /api/get-user/info/:username
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @return {User}
 */
function deleteUser(passport) {
    let router = express.Router();

    router.delete('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        if (req.params.username === req.user.username || req.user.adminStatus === true) {
            User.findOneAndRemove({ 'username': req.params.username }, function (error, user) {
                if (error) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                } else if (!user) {
                    return res.json({ errors: [{ message: 'Username not found' }] }).status(500);
                }
                user.deleteUserInfo(function(err) {
                    if (err) {
                        return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                    }
                    res.json({ message: 'Successfully deleted user' }).status(200);
                });
            });
        } else {
            res.json({ errors: [{ message: 'Unauthorized' }] });
        }
    });

    return router;
};

module.exports = deleteUser;
