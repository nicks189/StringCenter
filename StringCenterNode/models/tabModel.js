var mongoose = require('mongoose');
var Schema = mongoose.Schema;


var TabSchema = new Schema({
  author_username: {type: String, required: true, ref: 'User'},
  tab_name: {type: String, required: true},
  tab: {type: Object, required: true},
  dateCreated : {
      type: Date,
      required: true,
      default: Date.now
  }
});

TabSchema.statics.search = function(regex, callback) {
    Tab.find({
        $or: [
            { tab_name: regex }
        ]
    }, {}, { limit: 100 }, function(error, tabs) {
        if (error) {
            return callback(error);
        }
        // sort alphabetically
        // tabs.sort(function(a, b){
        //     return a.tab_name.toLowerCase().localeCompare(b.tab_name.toLowerCase());
        // });
        return callback(null, tabs);
    });
};

var Tab = mongoose.model('Tab', TabSchema);
module.exports = Tab;
