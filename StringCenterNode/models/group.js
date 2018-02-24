var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var GroupSchema = new Schema({
    groupName : {
        type: String,
        maxlength: [20, 'Group name cannot be longer than 20 characters'],
        required: true,
        unique: true
    }, 
});

GroupSchema.methods.validateAndSave = function(callback){
    var group = this;
    group.save(function(error, saved){
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
            var errorMessages = [];
            var key;
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

module.exports = mongoose.model('Group', GroupSchema);
