var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('../models/userModel.js');

var TabSchema = new Schema({
  author_username: {type: String, required: true, ref: 'User'},
  tab: {type: Object, required: true},
  
});

module.exports = mongoose.model('Tab', TabSchema);
