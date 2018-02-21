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
    }
});


module.exports = mongoose.model('UserGroup', UserGroupSchema);
