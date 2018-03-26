var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var util = require('../middleware/util');

var GroupSchema = new Schema({
    groupName : {
        type: String,
        maxlength: [20, 'Group name cannot be longer than 20 characters'],
        required: true,
        unique: true
    },
    description : {
        type: String,
        maxlength: [1000, 'Group description cannot be longer than 1000 characters'],
    },
    dateCreated : {
        type: Date,
        required: true,
        default: Date.now
    }
});

GroupSchema.statics.search = function(regex, callback) {
    Group.find({
        $or: [
            { groupName: regex }
        ]
    }, {}, { limit: 100 }, function(error, groups) {
        if (error) {
            return callback(error);
        }
        // sort alphabetically
        // groups.sort(function(a, b){
        //     return a.groupName.toLowerCase().localeCompare(b.groupName.toLowerCase());
        // });
        return callback(null, groups);
    });
};

GroupSchema.methods.validateAndSave = function(callback){
    util.validateAndSave(this, callback);
};

var Group = mongoose.model('Group', GroupSchema);
module.exports = Group;
