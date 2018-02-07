var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var mongoose = require('mongoose');
var mongoDB = "mongodb://127.0.0.1:27017/test";

/* TODO start connection to MongoDB
use throughout app such as in routes
//mongo connection*/
mongoose.connect(mongoDB, function(){
  console.log("connected to: " + mongoDB);
});
console.log("afterconnect");
mongoose.Promise = global.Promise;
this.db = mongoose.connection;
mongoose.connection.on('error', console.error.bind(console, 'MongoDB connection error:'));


var index = require('./routes/index');
var users = require('./routes/users');
var testRoutes = require('./routes/testRoutes');
var tabRoutes = require('./routes/tabRoutes');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));



app.use('/', index);
app.use('/users', users);
//dbroutes
app.use('/listTest', testRoutes);
app.use('/listTab', tabRoutes);;

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

/*
//added to expand routes
var router = express.Router(app);

// Error Handling
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
});
*/


module.exports = app;
