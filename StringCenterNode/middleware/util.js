exports.validateAndSave = function (model, callback) {
    model.save(function (error, saved) {
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
            for (let key in error.errors) {
                let err = {};
                err[key] = error.errors[key].message;
                errorMessages.push(err);
            }
            let errors = {};
            errors.errors = errorMessages;
            return callback(errors);
        }
        // No error, return the saved model
        return callback(null, saved);
    });
};