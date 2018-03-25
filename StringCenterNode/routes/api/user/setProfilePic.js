const express = require('express');
const User = require('../../../models/user');
const multer = require('multer');

const options = multer.diskStorage({
    destination: function(req, file, callback) {
        callback(null, './public/uploads/')
    },
    filename: function(req, file, callback) {
        callback(null, new Date().toISOString() + file.originalname);
    }
});
const filter = function(req, file, callback) {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
        callback(null, true);
    } else {
        callback(new Error('Incorrect file type'), false);
    }
};
const uploadFile = multer({
    storage: options,
    limits: {
        // 2 mB max file size
        fileSize: 1024 * 1024 * 2
    },
    fileFilter: filter
}).single('profilePic');

module.exports = function(passport) {
    let router = express.Router();

    router.put('/', passport.authenticate('jwt', { session: false }), function(req, res, next) {
        uploadFile(req, res, function(error) {
            if (error) {
               return res.json({ message: error.message });
            }
            console.log(req.file);
            User.findOne({username: req.user.username}, function (error, user) {
                if (error) {
                    return res.json({errors: [{message: 'Something went wrong'}]}).status(500);
                } else if (!user) {
                    return res.json({errors: [{message: 'Username not found'}]}).status(200);
                }
                User.findOneAndUpdate({username: req.user.username}, {
                    $set: {
                        profilePic: req.file.path,
                    }
                }, {new: true}, function (error, updatedUser) {
                    if (error) {
                        return res.json({errors: [{message: 'Username is already taken'}]}).status(400);
                    }
                    res.json(updatedUser).status(200);
                });
            });
        });
    });

    return router;
};