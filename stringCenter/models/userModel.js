var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var Tab = require('../models/tabModel.js');

var UserSchema = new Schema({
  username: {type: String, required: true, index: {unique: true}},
  password: {type: String, required: true},
  tabs: [{type: Schema.Types.ObjectId, ref: 'Tab'}]
});


module.exports = mongoose.model('User', UserSchema);
