const mongoose = require('mongoose');
const bcrypt = require('bcrypt-nodejs');
const Post = require('./post');
const UserGroup = require('./userGroup');
const UserFollows = require('./userFollows');
const util = require('../middleware/util');

let UserSchema = mongoose.Schema({
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
    dateCreated: {
        type: Date,
        required: true,
        default: Date.now
    },
    profilePic: {
        type: String,
        default: 'uploads/icon-user-default.png'
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

UserSchema.statics.search = function(regex, callback) {
    User.find({
        $or: [
            { username: regex }
        ]
    }, { password: 0}, { limit: 100 }, function(error, users) {
        if (error) {
            return callback(error);
        }
        // sort alphabetically
        // users.sort(function(a, b){
        //     return a.username.toLowerCase().localeCompare(b.username.toLowerCase());
        // });
        return callback(null, users);
    });
};

UserSchema.methods.validateAndSave = function(callback) {
    util.validateAndSave(this, callback);
};

UserSchema.methods.deleteUserInfo = function(callback) {
    // have to make these nested
    let user = this;
    Post.remove({ authorUsername: user.username }, function(e0) {
        if (e0) {
            return callback(e0);
        }
        UserGroup.remove({ username: user.username }, function(e1) {
            if (e1) {
                return callback(e1);
            }
            UserFollows.remove({ username: user.username }, function (e2) {
                if (e2) {
                    return callback(e2);
                }
                UserFollows.remove({ followsUsername: user.username }, function (e3) {
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

let User = mongoose.model('User', UserSchema);
module.exports = User;