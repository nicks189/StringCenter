var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('./user')


// Links users with who they follow, username -> follows -> followsUsername
var UserFollowersSchema = new Schema({
    username: {
        type: String,
        required: true,
        ref: 'User'
    },
    followsUsername: {
        type: String,
        required: true,
        ref: 'User'
    }
});

UserFollowersSchema.methods.validateAndSave = function(callback){
    var userFollows = this;

    userFollows.save(function(error, saved){
        /*
         * If an error occured, build array of errorMessages
         * and add them to an error object so we get the form
         * {
         *   errors: [
         *     ...
         *   ]
         * }
         */

        if(error){
            var key;
            var errorMessages = [];
            for(key in error.errors){
                var err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            var errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }

        //No errors
        return callback(null, saved);

    });
};


module.exports = mongoose.model('UserFollows', UserFollowersSchema);