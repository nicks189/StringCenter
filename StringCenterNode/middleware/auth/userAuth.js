const User = require('../../models/user');

/*
 * Using passports local strategy authentication
 */
const LocalStrategy = require('passport-local').Strategy;


module.exports = function(passport) {
    // Needs serialization for storing sessions
    passport.serializeUser(function(user, callback) {
        callback(null, user._id);
    });

    passport.deserializeUser(function(id, callback) {
        User.findById(id, function(error, user) {
            callback(error, user);
        });
    });

    /*
     * Local authentication strategy for the user authentication.
     * Need to set strategy as passReqToCallback so we can access req
     * object for flash message and req body fields.
     * TODO: update for REST API
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

    /*
     * TODO: update for REST API
     */
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
                let newUser = new User();
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
