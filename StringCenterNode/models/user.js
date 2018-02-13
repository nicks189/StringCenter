var mongoose = require('mongoose');
var bcrypt = require('bcrypt-nodejs');

var UserSchema = mongoose.Schema({
    username: {
        type: String,
        minlength: [6, 'Username must be at least 6 characters long'],
        maxlength: [32, 'Username cannot be longer than 32 characters'],
        required: true,
        unique: true,
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
    }
});

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
    var user = this;
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
            var errorMessages = [];
            var key;
            for (key in error.errors) {
                var err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            var errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }
        // No error, return the saved user
        return callback(null, saved);
    });
};

UserSchema.pre('save', function(next) {
    var user = this;
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