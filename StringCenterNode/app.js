var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var db = require('./db/db');
var mongoose = require('mongoose');
var passport = require('passport');
var expressSession = require('express-session');
var flash = require('connect-flash');

var app = express();

var index = require('./routes/index')(passport);
var about = require('./routes/about')(passport);
var signIn = require('./routes/signIn')(passport);
var signOut = require('./routes/signOut')(passport);
var register = require('./routes/register')(passport);
var editAccount = require('./routes/editAccount')(passport);

// connect to database
mongoose.connect(db.url);

// passport setup for authentication and session
app.use(passport.initialize());
app.use(passport.session());
app.use(expressSession({
    secret: 'top-secret',
    resave: true,
    saveUninitialized: true
}));
var userAuth = require('./passport/userAuth');
userAuth(passport);

// flash messaging setup
app.use(flash());

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

// body parser setup for parsing post requests
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(cookieParser());

app.use('/', index);
app.use('/about', about);
app.use('/sign-in', signIn);
app.use('/sign-out', signOut);
app.use('/register', register);
app.use('/edit-account', editAccount);

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

module.exports = app;
