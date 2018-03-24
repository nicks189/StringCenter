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
        default: Date.now
    }
});

GroupSchema.methods.validateAndSave = function(callback){
    util.validateAndSave(this, callback);
}

var Group = mongoose.model('Group', GroupSchema);
module.exports = Group;
