var mongoose = require('mongoose');
var bcrypt = require('bcrypt-nodejs');
var Post = require('./post');
var UserGroup = require('./userGroup');
var UserFollows = require('./userFollows');

var UserSchema = mongoose.Schema({
    username: {
        type: String,
        minlength: [6, 'Username must be at least 6 characters long'],
        maxlength: [32, 'Username cannot be longer than 32 characters'],
        required: true,
        unique: true,
        trim: true
    },
    description: {
        type: String,
        maxlength: [140, 'Description cannot be longer than 140 characters'],
        trim: true
    },
    firstName: {
        type: String,
        maxlength: [32, 'First name cannot be longer than 32 characters'],
        trim: true
    },
    lastName: {
        type:String,
        maxlength: [32, 'Last name cannot be longer than 32 characters'],
        trim: true
    },
    password: {
        type: String,
        minlength: [6, 'Password must be at least 6 characters long'],
        maxlength: [32, 'Password cannot be longer than 32 characters'],
        required: true,
        trim: true
    },
    timestamp : {
        type: Date,
        default: Date.now
    }
});

// password is the new unhashed password
UserSchema.statics.comparePasswords = function(password, matchedPassword) {
    // Should change to async
    return bcrypt.compareSync(password, matchedPassword);
};

UserSchema.statics.hashPasswordSync = function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(10));
};

UserSchema.statics.hashPassword = function(password, callback) {
    bcrypt.genSalt(10, function(error, salt) {
        if (error) {
            return callback(error);
        }
        bcrypt.hash(password, salt, null, function(error, hashedPassword) {
            return callback(error, hashedPassword);
        });
    });
};

UserSchema.statics.passwordConfirm = function(password, confirmPassword) {
    return password === confirmPassword;
};

/*
 * Default authentication check. If no session exists, redirect to sign in page.
 * This is used in the demo routes, not the API
 */
UserSchema.statics.isAuthenticated = function(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect('/sign-in');
};

UserSchema.methods.validateAndSave = function(callback) {
    let user = this;
    user.save(function (error, saved) {
        /*
         * If an error occured, build array of errorMessages
         * and add them to an error object so we get the form
         * {
         *   errors: [
         *     ...
         *   ]
         * }
         */
        if (error) {
            let errorMessages = [];
            let key;
            for (key in error.errors) {
                let err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            let errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }
        // No error, return the saved user
        return callback(null, saved);
    });
};

UserSchema.methods.deleteStuff = function(callback) {
    // have to make these nested
    let user = this;
    Post.remove({ 'authorUsername': user.username }, function(e0) {
        if (e0) {
            return callback(e0);
        }
        UserGroup.remove({ 'username': user.username }, function(e1) {
            if (e1) {
                return callback(e1);
            }
            UserFollows.remove({ 'username': user.username }, function (e2) {
                if (e2) {
                    return callback(e2);
                }
                UserFollows.remove({ 'followsUsername': user.username }, function (e3) {
                    if (e3) {
                        return callback(e3);
                    }
                    callback(null);
                });
            });
        });
    });
};

UserSchema.pre('save', function(next) {
    let user = this;
    UserSchema.statics.hashPassword(user.password, function(error, hashedPassword) {
        if (error) {
            next(error);
        }
        user.password = hashedPassword;
        next();
    });
});

var User = mongoose.model('User', UserSchema);
module.exports = User;