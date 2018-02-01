var LocalStrategy = require('passport-local').Strategy;
var bcrypt = require('bcrypt-nodejs');
var User = require('../models/user');


module.exports = function(passport) {
    // Needs serialization for storing sessions
    passport.serializeUser(function(user, done) {
        done(null, user._id);
    });

    passport.deserializeUser(function(id, done) {
        User.findById(id, function(err, user) {
            done(err, user);
        });
    });

    // Need to set strategy as passReqToCallback so we can access req object
    passport.use('signIn', new LocalStrategy({ passReqToCallback : true },
        function(req, username, password, callback) {
            User.findOne({ 'username' :  username}, function(error, user) {
                if (error) {
                    return callback(error);
                } else {
                    if (user && User.comparePasswords(user.password, password)) {
                        // Username and password match
                        return callback(null, user);
                    } else {
                        return callback(null, false, req.flash('errorMessage', 'Invalid username or password'));
                    }
                }
            });
        })
    );
};
