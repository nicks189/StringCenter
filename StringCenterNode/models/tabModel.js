var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var User = require('./user');

var TabSchema = new Schema({
  author_username: {type: String, required: true, ref: 'User'},
  tab_name: {type: String, required: true},
  tab: {type: Object, required: true},
  timestamp : {
      type: Date,
      default: Date.now
  }
});

var Tab = mongoose.model('Tab', TabSchema);
module.exports = Tab;
