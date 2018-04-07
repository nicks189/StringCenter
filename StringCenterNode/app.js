// this file is gitignored so it has to be added
const config = require('./config/config');

const express = require('express');
const path = require('path');
const favicon = require('serve-favicon');
const logger = require('morgan');
const bodyParser = require('body-parser');
const expressSession = require('express-session');
const MongoStore = require('connect-mongo')(expressSession);
const cookieParser = require('cookie-parser');
const passport = require('passport');
const mongoose = require('mongoose');
const flash = require('connect-flash');

let app = express();

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

let userAuth = require('./middleware/auth/userAuth');
userAuth(passport);

let apiAuth = require('./middleware/auth/apiAuth');
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
let index = require('./routes/demo/index')(passport);
let about = require('./routes/demo/about')(passport);
let signIn = require('./routes/demo/signIn')(passport);
let signOut = require('./routes/demo/signOut')(passport);
let register = require('./routes/demo/register')(passport);
let editAccount = require('./routes/demo/editAccount')(passport);

// api routes
// user
let getAllUsers = require('./routes/api/user/getUser').getAllUsers(passport);
let getUserInfo = require('./routes/api/user/getUser').getUserInfo(passport);
let deleteUser = require('./routes/api/user/deleteUser')(passport);
let apiSignIn = require('./routes/api/user/signIn')(passport);
let apiRegister= require('./routes/api/user/register')(passport);
let updateUser = require('./routes/api/user/updateUser')(passport);
let searchUser = require('./routes/api/user/searchUser')(passport);
let setProfilePic = require('./routes/api/user/setProfilePic')(passport);

// tab
let tabRoutes = require('./routes/api/tab/tabRoutes')(passport);

// post
let createPost = require('./routes/api/post/createPost')(passport);
let getPost = require('./routes/api/post/getPost')(passport);
let deletePost = require('./routes/api/post/deletePost')(passport);
let updatePost = require('./routes/api/post/updatePost')(passport);

// group
let joinGroup = require('./routes/api/group/joinGroup')(passport);
let leaveGroup = require('./routes/api/group/leaveGroup')(passport);
let getGroupPosts = require('./routes/api/group/getGroupPosts')(passport);
let getGroupMembers = require('./routes/api/group/getGroupMembers')(passport);
let createGroup = require('./routes/api/group/createGroup')(passport);
let deleteGroup = require('./routes/api/group/deleteGroup')(passport);
let getGroup = require('./routes/api/group/getGroup')(passport);
let getGroups = require('./routes/api/group/getGroups')(passport);
let getUserGroupAdminStatus = require('./routes/api/group/getUserGroupAdminStatus')(passport);

// followers/following
let getFollower = require('./routes/api/follower/getFollower')(passport);
let followUser = require('./routes/api/follower/followUser')(passport);
let unfollowUser = require('./routes/api/follower/unfollowUser')(passport);

// general
let search = require('./routes/api/general/search')(passport);


// demo routes
app.use('/', index);
app.use('/about', about);
app.use('/sign-in', signIn);
app.use('/sign-out', signOut);
app.use('/register', register);
app.use('/edit-account', editAccount);

// api routes
// user
app.use('/api/get-user/all', getAllUsers);
app.use('/api/get-user/info', getUserInfo);

app.use('/api/delete-user', deleteUser);
app.use('/api/sign-in', apiSignIn);
app.use('/api/register', apiRegister);
app.use('/api/update-user', updateUser);
app.use('/api/search-user', searchUser);
app.use('/api/set-profile-pic', setProfilePic);

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
app.use('/api/delete-group', deleteGroup);
app.use('/api/get-group', getGroup);
app.use('/api/get-groups', getGroups);
app.use('/api/get-admin-status', getUserGroupAdminStatus);


// following/followers
app.use('/api/get-follower', getFollower);
app.use('/api/follow-user', followUser);
app.use('/api/unfollow-user', unfollowUser);

// general
app.use('/api/search', search);

// const userTests = require('./tests/userTests');
// userTests.testCompare();

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    let err = new Error('Not Found');
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

    // Render error as json
    // res.json({ errors: [{ message: err.message }] });
});

module.exports = app;
