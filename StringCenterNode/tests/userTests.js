const fs = require('fs');
const User = require('../models/user');
exports.test = function () {
    let imgPath = '/home/nick/Pictures/favicon/favicon-16x16.png';

    let newUser = new User();
    newUser.firstName = 'test';
    newUser.lastName = 'user';
    newUser.username = 'thisisatestuser';
    newUser.password = 'secret';
    newUser.description = 'Testy testy testy';
    newUser.profilePic.data = fs.readFileSync(imgPath);
    newUser.profilePic.contentType = 'image/png';
    console.log(newUser);
    console.log(newUser.validateAndSave);
    newUser.validateAndSave(function (errors, user) {
        console.log('hello world');
        if (errors) {
            console.log(errors);
        } else {
            console.log(user);
        }
    });
};

exports.testCompare = function() {
    User.find({ username: 'thisisatestuser' }, function(error, user) {
        if (error) {
            console.log(error.message);
        } else {

        }
    });
};
