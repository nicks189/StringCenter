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

UserSchema.statics.comparePasswords = function(matchedPassword, password) {
    // return bcrypt.compareSync(matchedPassword, password);
    return matchedPassword === password;
};

var User = mongoose.model('User', UserSchema);
module.exports = User;