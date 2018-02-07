var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var TabSchema = new Schema({
  author: {type: Schema.Types.ObjectId},
  tab: {type: Object, required: true},
});

module.exports = mongoose.model('Tab', TabSchema);
