var tab = require('../middleware/tab.js');

tab.initTab("blank", 4, ["E", "A", "D", "G"], 4);

console.log(tab.measures[0].strings);
