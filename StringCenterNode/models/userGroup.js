var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('./user');
var Group = require('./group');
var util = require('../middleware/util');

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
    dateCreated : {
        type: Date,
        required: true,
        default: Date.now
    }
});

UserGroupSchema.methods.validateAndSave = function(callback){
    util.validateAndSave(this, callback);
}

var UserGroup = mongoose.model('UserGroup', UserGroupSchema);
module.exports = UserGroup;
