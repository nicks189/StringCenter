//mongo module
var MongoClient = require('mongodb').MongoClient;


/*
//create server instance for mongodb
var tabdbServerInstance = new mongo.Server('localhost', 27017, {auto_reconnect: true});

//get db reference
var tabdbRef = new mongo.Db('tabdb', tabdbServerInstance);
console.log(tabdbRef);
//connect to db Server
tabdbRef.connect(function(err, dbref){
  if(!err){
    console.log("connected to tabdb");
  }
});

//close
//tabdbRef.close();

//retrieve db reference
tabdbRef.collection('tabCollection', function(err, collectionRef){

});
*/


MongoClient.connect("mongodb://localhost:27017/tabdb", function(err, database){
  if(err) throw err;
  console.log("connected to tabdb");
  database = database.db('test');
  database.collection('test', function(err, collection){
    for(var i = 0; i < 10; i++){
      collection.insert({id: i, name: 'person' + i, job: 'garbage' + (100 - i)});
    }

    database.collection('test').count(function(err, count){
      if(err) throw err;
      console.log('Rows: ' + count);
    });
  });
});


module.exports = tabInserter;
