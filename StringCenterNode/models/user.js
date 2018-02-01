var mongoose = require('mongoose');

var UserSchema = mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    firstName: {
        type: String,
        trim: true
    },
    lastName: {
        type:String,
        trim: true
    },
    password: {
        type: String,
        required: true,
        trim: true
    },
    confirmPassword: {
        type: String,
        required: true,
        trim: true
    }
});

UserSchema.statics.authenticate = function(user, func) {
    User.findOne({ username: user.username})
        .exec(function(error, matchedUser) {
            if (error) {
                return func(error, null);
            } else {
                if (matchedUser !== null && user.password === matchedUser.password) {
                    return func(null, matchedUser);
                } else {
                    return func(new Error('Invalid credentials').status(401), null);
                }
            }
        });
};

var User = mongoose.model('User', UserSchema);
module.exports = User;