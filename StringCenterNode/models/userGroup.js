var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('./user')
var Group = require('./group');


//Schema to link users with groups, 'middleman'
var UserGroupSchema = new Schema({
    username: {
        type: String,
        required: true,
        ref: 'User'
    },
    groupName: {
        type: String,
        required: true,
        ref: 'Group'
    },
    admin : {
        type: Boolean,
        required: true,
        default: false
    },
    moderator : {
        type: Boolean,
        required: true,
        default: false
    },
    timestamp : {
        type: Date,
        default: Date.now
    }
});

UserGroupSchema.methods.validateAndSave = function(callback){
    var userGroup = this;

    userGroup.save(function(error, saved){
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
}

var UserGroup = mongoose.model('UserGroup', UserGroupSchema);
module.exports = UserGroup;
