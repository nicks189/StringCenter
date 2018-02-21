var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var GroupSchema = new Schema({
    groupName : {
        type: String,
        maxlength: [20, 'Group name cannot be longer than 20 characters'],
        required: true
    }
});

module.exports = mongoose.model('Group', GroupSchema);
