const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const User = require('./user');
const util = require('../middleware/util');

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
        required: true,
        default: Date.now
    }
});

UserFollowsSchema.methods.validateAndSave = function(callback){
    util.validateAndSave(this, callback);
};

let UserFollows = mongoose.model('UserFollows', UserFollowsSchema);
module.exports = UserFollows;