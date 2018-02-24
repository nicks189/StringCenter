// this file is gitignored so it has to be added
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
app.use(cookieParser(config.session.key));
app.use(passport.initialize());
app.use(passport.session());

var userAuth = require('./middleware/auth/userAuth');
userAuth(passport);

var apiAuth = require('./middleware/auth/apiAuth');
apiAuth(passport);

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
var getUser = require('./routes/api/user/getUser')(passport);
var deleteUser = require('./routes/api/user/deleteUser')(passport);
var apiSignIn = require('./routes/api/user/signIn')(passport);
var apiRegister= require('./routes/api/user/register')(passport);
var updateUser = require('./routes/api/user/updateUser')(passport);
var tabRoutes = require('./routes/api/tab/tabRoutes')(passport);
var createPost = require('./routes/api/post/createPost')(passport);
var getPost = require('./routes/api/post/getPost')(passport);
var deletePost = require('./routes/api/post/deletePost')(passport);
var updatePost = require('./routes/api/post/updatePost')(passport);

var joinGroup = require('./routes/api/group/joinGroup')(passport);
var leaveGroup = require('./routes/api/group/leaveGroup')(passport);
var getGroupPosts = require('./routes/api/group/getGroupPosts')(passport);
var getGroupMembers = require('./routes/api/group/getGroupMembers')(passport);
var createGroup = require('./routes/api/group/createGroup')(passport);


// demo routes
app.use('/', index);
app.use('/about', about);
app.use('/sign-in', signIn);
app.use('/sign-out', signOut);
app.use('/register', register);
app.use('/edit-account', editAccount);

// api routes
// user
app.use('/api/get-user', getUser);
app.use('/api/delete-user', deleteUser);
app.use('/api/sign-in', apiSignIn);
app.use('/api/register', apiRegister);
app.use('/api/update-user', updateUser);

// tab
app.use('/api/tab', tabRoutes);

// post
app.use('/api/create-post', createPost);
app.use('/api/get-post', getPost);
app.use('/api/delete-post', deletePost);
app.use('/api/update-post', updatePost);

// group
app.use('/api/join-group', joinGroup);
app.use('/api/leave-group', leaveGroup);
app.use('/api/get-group-posts', getGroupPosts);
app.use('/api/get-group-members', getGroupMembers);
app.use('/api/create-group', createGroup);

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
