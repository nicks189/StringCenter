const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const User = require('./user')


// Links users with who they follow, username -> follows -> followsUsername
let UserFollowsSchema = new Schema({
    username: {
        type: String,
        required: true,
        ref: 'User'
    },
    followsUsername: {
        type: String,
        required: true,
        ref: 'User'
    },
    dateCreated: {
        type: Date,
        default: Date.now
    }
});

UserFollowsSchema.methods.validateAndSave = function(callback){
    let userFollows = this;

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
            let key;
            let errorMessages = [];
            for(key in error.errors){
                let err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            let errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }

        //No errors
        return callback(null, saved);

    });
};

let UserFollows = mongoose.model('UserFollows', UserFollowsSchema);
module.exports = UserFollows;