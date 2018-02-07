var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('../models/userModel.js');

var TabSchema = new Schema({
  author: {type: Schema.Types.ObjectId, ref: 'User'},
  tab: {type: Object, required: true},
});

module.exports = mongoose.model('Tab', TabSchema);
