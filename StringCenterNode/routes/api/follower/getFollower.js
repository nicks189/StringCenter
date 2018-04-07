const express = require('express');
const UserFollows = require('../../../models/userFollows');

/**
 * Get all users followed by {username}, or by the current
 * user if username is empty
 * @param  {HttpRequest}   req  url: /api/get-follower/following/:username
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {userFollows}   List of relationships
 */
module.exports.getFollowing = function getFollowing(passport) {
    let router = express.Router();

    router.get('/', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        UserFollows.find({username: req.user.username}, function (error, userFollows) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (userFollows.length === 0) {
                return res.json({errors: [{message: 'Not following anyone'}]}).status(400);
            }
            userFollows.sort(function (a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let following = [];
            userFollows.forEach(function (e) {
                following.push(e.followsUsername);
            });
            res.json({following: following}).status(200);
        });
    });

    router.get('/:username', passport.authenticate('jwt', {session: false}), function (req, res, next) {
        UserFollows.find({username: req.params.username}, function (error, userFollows) {
            if (error) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            } else if (userFollows.length === 0) {
                return res.json({errors: [{message: 'Not following anyone'}]}).status(400);
            }
            userFollows.sort(function (a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let following = [];
            userFollows.forEach(function (e) {
                following.push(e.followsUsername);
            });
            res.json({following: following}).status(200);
        });
    });

    return router;
};

/**
 * Get all followers of username, or followers of current user
 * if username is empty
 * @param  {HttpRequest}   req  url: /api/get-follower/followers/:username
 * @param  {HttpResponse}  res
 * @param  {Function}      next
 * @param  {Passport}      passport
 * @return {userFollow}    List of relationships
 */
module.exports.getFollowers = function getFollowers(passport) {
    let router = express.Router();

    router.get('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ followsUsername: req.user.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'No followers' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let followers = [];
            userFollows.forEach(function(e) {
                 followers.push(e.username);
            });
            res.json({ followers: followers }).status(200);
        });
    });

    router.get('/:username', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        UserFollows.find({ followsUsername: req.params.username}, function(error, userFollows) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (userFollows.length === 0) {
                return res.json({ errors: [{ message: 'No followers' }] }).status(400);
            }
            userFollows.sort(function(a, b) {
                // sort by most recent dateCreated
                return new Date(b.dateCreated) - new Date(a.dateCreated);
            });
            let followers = [];
            userFollows.forEach(function(e) {
                 followers.push(e.username);
            });
            res.json({ followers: followers }).status(200);
        });
    });

    return router;
};