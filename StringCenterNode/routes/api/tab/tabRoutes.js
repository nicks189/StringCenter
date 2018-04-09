var express = require('express');
var router = express.Router();
var Tab = require('../../../models/tabModel.js');
var cb = require('../../../middleware/mongoCallback.js');
var validateTab = require('../../../middleware/auth/tabAuth.js');

/*
   Tab Object stucture
   {
   "author_username": "xxxx",
   "tab_name": "Tab",
   "tab": {
       "info": "Tab",
       "measureCount": "1",
       "measures": [
           {
               "info": "first measure",
               "tuning": "EADG",
               "stringCount": "4",
               "strings": [
                   {
                       "notes": [
                           "-",
                           "-",
                           "-",
                           "-"
                       ],
                       "tuning": "E"
                   },
                   {
                       "notes": [
                           "-",
                           "-",
                           "-",
                           "-"
                       ],
                       "tuning": "A"
                   },
                   {
                       "notes": [
                           "-",
                           "-",
                           "-",
                           "-"
                       ],
                       "tuning": "D"
                   },
                   {
                       "notes": [
                           "-",
                           "-",
                           "-",
                           "-"
                       ],
                       "tuning": "G"
                   }
               ]
           }
       ]
   }
}
*/

/**
 * Get all tabs
 * @param {passport} passport  used for authentication
 * @param  {HttpRequest}    req  url: /api/tab
 * @param  {HttpResponse}   res  {tabs}
 * @param  {Function}       next
 * @return {Tab}       an array of tabs {tabs:Tab} (tab obj at top of src file)
 */
module.exports.getAllTabs = function(passport){
    router.get('/', passport.authenticate('jwt', {session: false}), function(req, res, next) {
        Tab.find(function(err, Tab){
            if (err) {
              return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }
            res.json({ tabs: Tab }).status(200);
        });
    });
    return router;
}


/**
 * Get tab by tab id
 * @param {passport} passport  used for authentication
 * @param  {HttpGetRequest}    req  url: /api/tab/findTabByID/:id
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Tab}       a tab object having an id matching that of the request (tab obj at top of src file)
 */
module.exports.findTabsById = function(passport){
    router.get('/findTabById/:id', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        Tab.findById(req.params.id, function(error, tab) {
            if (error) {
                return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            } else if (!tab) {
                return res.json({ errors: [{ message: 'Tab not found' }] }).status(400);
            }
            res.json(tab).status(200);
        });
    });
    return router;
}


/**
 * Get tabs with username sent in parameter of request or by using authentication (for logged in user)
 * @param {passport} passport  used for authentication
 * @param  {HttpGetRequest}    req   url: /api/tab/findTabsByUser/:username
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Tab}        tabs whose author_username matches the request (tab obj at top of src file)
 */
module.exports.findTabsByUser = function(passport){
    router.get('/findTabsByUser/:username',  passport.authenticate('jwt', {session: false}), function(req, res, next){
        Tab.find().where('author_username').equals(req.params.username).exec(function (err, Tab) {
            if (err) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            }
            res.json({tabs: Tab}).status(200);
        });
    });

    router.get('/findTabsByUser',  passport.authenticate('jwt', {session: false}), function(req, res, next){
        Tab.find().where('author_username').equals(req.user.username).exec(function (err, Tab) {
            if (err) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            }
            res.json({tabs: Tab}).status(200);
        });
    });
    return router;
}


//authentication
/**
 * Create new tab with tab object from body request and store it in the database (tab obj at top of src file)
 * @param {passport} passport  used for authentication
 * @param  {HttpPostRequest}    req  url: /api/tab/findTabsByUser
 * @param  {HttpResponse}   res
 * @param  {Function}       next
 * @return {Tab}       returns the created tab back to the client (tab obj at top of src file)
 */
module.exports.createTab = function(passport){
    router.post('/createTab', function(req, res, next){
        if(validateTab.valid(req.body.tab)){
            // add tab to database since it is valid
            var tab = req.body.tab;
            var tabDetail = {author_username: req.body.author_username, tab_name: req.body.tab_name, tab: tab};
            var tabModel = new Tab(tabDetail);
            tabModel.save(function(err, tab){
                if(err){
                    console.log("ERROR" + err);
                    cb.cb(err, null);
                    res.send("Tab Creation Failed");
                } else{
                    console.log(tab);
                    cb.cb(null, tab);
                    res.json(tab).status(201);
                }
            });
        } else{
            res.json({ errors: [{ message: 'Invalid request' }] }).status(400);
        }
    });
    return router;
}
