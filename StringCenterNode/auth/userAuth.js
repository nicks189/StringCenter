var LocalStrategy = require('passport-local').Strategy;
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

    /*
     * Local authentication strategy for the user authentication. Can update this
     * for REST api. Need to set strategy as passReqToCallback so we can access req
     * object for flash message.
     */
    passport.use('signIn', new LocalStrategy({ passReqToCallback : true },
        function(req, username, password, callback) {
            // See if matching username exists in database
            User.findOne({ 'username' :  username}, function(error, user) {
                if (error) {
                    return callback(error);
                } else {
                    if (user && User.comparePasswords(password, user.password)) {
                        // Username and password match
                        return callback(null, user);
                    } else {
                        // Either username or password were wrong. This can be changed.
                        return callback(null, false, req.flash('errorMessage', 'Invalid username or password'));
                    }
                }
            });
        })
    );

    passport.use('register', new LocalStrategy({ passReqToCallback : true },
        function(req, username, password, callback) {
            User.findOne({ 'username' :  username}, function(error, user) {
                if (error) {
                    return callback(error);
                } else if (user) {
                    return callback(null, false, req.flash('errorMessage', 'Username is already taken'));
                } else if (!(User.passwordConfirm(password, req.body.confirmPassword))) {
                    return callback(null, false, req.flash('errorMessage', 'Passwords don\'t match'));
                }
                var newUser = new User();
                newUser.username = username;
                newUser.password = password;
                newUser.firstName = req.body.firstName;
                newUser.lastName = req.body.lastName;

                newUser.save(function(error) {
                    if (error) {
                        return callback(error);
                    }
                    return callback(null, newUser);
                });
            });
        })
    );
};
