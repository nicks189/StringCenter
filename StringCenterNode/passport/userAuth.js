var LocalStrategy   = require('passport-local').Strategy;
var bcrypt = require('bcrypt-nodejs');
var User = require('../models/user');


module.exports = function(passport) {
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

    // passport.use('register', new LocalStrategy({ passReqToCallback : true },
    //     function(req, user, done) {
    //         User.findOrCreateUser = function() {
    //             User.findOne({ 'username' :  username }, function(err, user) {
    //                 // In case of any error, return using the done method
    //                 if (err){
    //                     console.log('Error in SignUp: '+err);
    //                     return done(err);
    //                 }
    //                 // already exists
    //                 if (user) {
    //                     console.log('User already exists with username: '+username);
    //                     return done(null, false, req.flash('message','User Already Exists'));
    //                 } else {
    //                     // if there is no user with that email
    //                     // create the user
    //                     var newUser = new User();

    //                     // set the user's local credentials
    //                     newUser.username = username;
    //                     newUser.password = createHash(password);
    //                     newUser.email = req.param('email');
    //                     newUser.firstName = req.param('firstName');
    //                     newUser.lastName = req.param('lastName');

    //                     // save the user
    //                     newUser.save(function(err) {
    //                         if (err){
    //                             console.log('Error in Saving user: '+err);
    //                             throw err;
    //                         }
    //                         console.log('User Registration succesful');
    //                         return done(null, newUser);
    //                     });
    //                 }
    //             });
    //         };
    //         // Delay the execution of findOrCreateUser and execute the method
    //         // in the next tick of the event loop
    //         process.nextTick(findOrCreateUser);
    //     })
    // );

    // var createHash = function(password) {
    //     return bcrypt.hashSync(password, bCrypt.genSaltSync(10), null);
    // };
};
