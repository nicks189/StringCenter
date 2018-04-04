var express = require('express');
var router = express.Router();
var Tab = require('../../../models/tabModel.js');
var cb = require('../../../middleware/mongoCallback.js');
var validateTab = require('../../../middleware/auth/tabAuth.js');


module.exports = function(passport){
    /**
     * Get all tabs
     * @param  {HttpRequest}    req  url: 3000/api/tab
     * @param  {HttpResponse}   res  {tabs}
     * @param  {Function}       next
     * @return {HttpResponse}        an array of tabs {tabs:Tab}
     */
    router.get('/', passport.authenticate('jwt', {session: false}), function(req, res, next) {
        Tab.find(function(err, Tab){
            if (err) {
              return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }
            res.json({ tabs: Tab }).status(200);
        });
    });

    /**
     * Get tab by tab id
     * @param  {HttpRequest}    req  url: 3000/api/tab/findTabByID/:id
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {HttpResponse}        a tab object having an id matching that of the request
     */
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


    /**
     * Get tabs with username sent in parameter of request
     * @param  {HttpRequest}    req   url: 3000/api/tab/findTabsByUser/:username
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {HttpResponse}         tabs whose author_username matches the request
     */
    router.get('/findTabsByUser/:username',  passport.authenticate('jwt', {session: false}), function(req, res, next){
        Tab.find().where('author_username').equals(req.params.username).exec(function (err, Tab) {
            if (err) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            }
            res.json({tabs: Tab}).status(200);
        });
    });


    /**
     * Get tabs with username from authentication (the user currently logged in)
     * @param  {HttpRequest}    req  url: 3000/api/tab/findTabsByUser
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {HttpResponse}        tabs for the current user
     */
    router.get('/findTabsByUser',  passport.authenticate('jwt', {session: false}), function(req, res, next){
        Tab.find().where('author_username').equals(req.user.username).exec(function (err, Tab) {
            if (err) {
                return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
            }
            res.json({tabs: Tab}).status(200);
        });
    });


    /**
     * Create new tab with data from request and store it in the database
     * @param  {HttpRequest}    req  url: 3000/api/tab/findTabsByUser
     * @param  {HttpResponse}   res
     * @param  {Function}       next
     * @return {HttpResponse}        returns the created tab back to the client
     */
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
};
