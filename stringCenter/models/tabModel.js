var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var TabSchema = new Schema({
  tab: {type: Object, required: true},
});

module.exports = mongoose.model('Tab', TabSchema);
