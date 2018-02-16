var User = require('../models/user');
var config = require('../config/config');

/*
 * Using passports jwt strategy authentication
 */
var JWTStrategy = require('passport-jwt').Strategy;
var JWT = require('passport-jwt').ExtractJwt;

module.exports = function(passport) {

    var operations = {};
    operations.jwtFromRequest = JWT.fromAuthHeaderAsBearerToken();
    operations.secretOrKey = config.session.key;

    // JwtStrategy for API routes
    passport.use(new JWTStrategy(operations, function(jwt_payload, callback) {
        /*
         * payload contains the unencrypted user.id so
         * we can query the db for it
         */
        User.findById(jwt_payload, function(error, user) {
            if (error) {
                return callback(error, false);
            } else if (!user) {
                var err = new Error('User doesn\'t exist');
                return callback(err, false);
            }
            // sets req.user to user
            callback(null, user);
        });
    }));
};