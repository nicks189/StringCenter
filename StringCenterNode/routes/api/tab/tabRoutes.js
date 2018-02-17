var express = require('express');
var router = express.Router();
var Tab = require('../../../models/tabModel.js');
var mongoose = require('mongoose');
var cb = require('../../../middleware/mongoCallback.js');
var validateTab = require('../../../auth/tabAuth.js');


module.exports = function(passport){
    //get all tabs
    router.get('/', passport.authenticate('jwt', {session: false}), function(req, res, next) {
        Tab.find(function(err, Tab){
            if (err) {
              return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
            }
            res.json({ tabs: Tab }).status(200);
        });
    });

    //get tabs with user name sent in post body as author_username
    router.get('/findTabsByUser',  passport.authenticate('jwt', {session: false}), function(req, res, next){
        console.log(req.body);
        Tab.find().
            where('author_username').equals(req.user.username).exec(function(err, Tab){
                if (err) {
                    return res.json({ errors: [{ message: 'Something went wrong' }] }).status(500);
                }
                res.json({ tabs: Tab }).status(200);
            });
    });

    //create new tab with json data from post
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
                    res.json(tab);
                }
            });
        } else{
            res.json({ errors: [{ message: 'Invalid tab' }] }).status(400);
        }
    });

    return router;
}
