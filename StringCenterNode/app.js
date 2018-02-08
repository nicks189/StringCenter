// this file is gitignored so make it has to be added
var config = require('./config/config');

var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');
var expressSession = require('express-session');
var MongoStore = require('connect-mongo')(expressSession);
var cookieParser = require('cookie-parser');
var passport = require('passport');
var mongoose = require('mongoose');
var flash = require('connect-flash');

var app = express();

// connect to database
mongoose.connect(config.db.url);

// passport and session setup
app.use(expressSession({
    secret: config.session.key,
    resave: true,
    saveUninitialized: true,
    store: new MongoStore({
        mongooseConnection: mongoose.connection
    })
}));
app.use(cookieParser('top-secret'));
app.use(passport.initialize());
app.use(passport.session());

var userAuth = require('./auth/userAuth');
userAuth(passport);

// flash messaging setup
app.use(flash());

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

// body parser setup for parsing requests
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(express.static(path.join(__dirname, 'public')));

// demo routes
var index = require('./routes/demo/index')(passport);
var about = require('./routes/demo/about')(passport);
var signIn = require('./routes/demo/signIn')(passport);
var signOut = require('./routes/demo/signOut')(passport);
var register = require('./routes/demo/register')(passport);
var editAccount = require('./routes/demo/editAccount')(passport);

// api routes
var getUser = require('./routes/api/getUser')(passport);
var apiSignIn = require('./routes/api/signIn')(passport);
var apiSignOut = require('./routes/api/signOut')(passport);
var apiRegister= require('./routes/api/register')(passport);
var updateUser = require('./routes/api/updateUser')(passport);

// demo routes
app.use('/', index);
app.use('/about', about);
app.use('/sign-in', signIn);
app.use('/sign-out', signOut);
app.use('/register', register);
app.use('/edit-account', editAccount);

// api routes
app.use('/api/get-user', getUser);
app.use('/api/sign-in', apiSignIn);
app.use('/api/sign-out', apiSignOut);
app.use('/api/register', apiRegister);
app.use('/api/update-user', updateUser);

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
