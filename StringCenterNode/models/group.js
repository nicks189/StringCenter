var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var util = require('../middleware/util');

var GroupSchema = new Schema({
    groupName : {
        type: String,
        maxlength: [20, 'Group name cannot be longer than 20 characters'],
        required: true,
        unique: true,
        trim: true
    },
    description : {
        type: String,
        maxlength: [500, 'Group description cannot be longer than 1000 characters'],
        default: "",
        trim: true
    },
    dateCreated : {
        type: Date,
        required: true,
        default: Date.now,
        trim: true
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
