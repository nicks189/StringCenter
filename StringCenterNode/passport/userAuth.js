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

    passport.use('signIn', new LocalStrategy({ passReqToCallback : true },
        function(req, username, password, done) {
            User.findOne({ 'username' :  username}, function(error, user) {
                if (error) {
                    return done(error);
                } else {
                    if (user && User.comparePasswords(user.password, password)) {
                        // Username and password match
                        return done(null, user);
                    } else {
                        return done(null, false, req.flash('errorMessage', 'Invalid credentials'));
                    }
                }
            });
        })
    );
};
