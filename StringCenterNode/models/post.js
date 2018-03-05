const mongoose = require('mongoose');
const Tab = require('./tabModel');
const User = require('./user');
const Group = require('./group');

let PostSchema = mongoose.Schema({
    title: {
        type: String,
        maxlength: [64, 'Title cannot be longer than 64 characters'],
        required: true,
        trim: true
    },
    content: {
        type: String,
        maxlength: [500, 'Content cannot be longer than 500 characters'],
        required: true,
        trim: true
    },
    // as of now, posts can only contain one tab
    tabId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Tab'
    },
    groupName: {
        type: String,
        ref: 'Group'
    },
    authorUsername: {
        type: String,
        required: true,
        ref: 'User'
    },
    dateCreated: {
        type: Date,
        default: Date.now
    }
});

// Verify that the user trying to delete actually created the post
PostSchema.statics.validateUserAndRemove = function(id, username, callback) {
    PostSchema.findById(id, function (error, post) {
        if (error) {
            return callback(error);
        } else if (!post) {
            return callback(null, false);
        } else if (post.authorUsername !== username) {
            let err = new Error('Unauthorized');
            return callback(err);
        }
        post.remove(function (er, removed) {
            if (er) {
                return callback(er);
            }
            return callback(null, removed);
        });
    });
};

PostSchema.methods.validateAndSave = function(callback) {
    let post = this;
    post.save(function (error, saved) {
        /*
         * If an error occured, build array of errorMessages
         * and add them to an error object so we get the form
         * {
         *   errors: [
         *     ...
         *   ]
         * }
         */
        if (error) {
            let errorMessages = [];
            let key;
            for (key in error.errors) {
                let err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            let errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }
        // No error, return the saved post
        return callback(null, saved);
    });
};

let Post = mongoose.model('Post', PostSchema);
module.exports = Post;
