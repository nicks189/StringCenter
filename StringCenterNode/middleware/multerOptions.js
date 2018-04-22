const multer = require('multer');

const storage = multer.diskStorage({
    destination: function(req, file, callback) {
        callback(null, './public/uploads/')
    },
    filename: function(req, file, callback) {
        callback(null, new Date().toISOString() + file.originalname);
    }
});

const filter = function(req, file, callback) {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png'
        || file.mimetype === 'image/jpg' || file.mimetype === 'application/octet-stream') {
        callback(null, true);
    } else {
        callback(new Error('Incorrect file type'), false);
    }
};

module.exports = {
    storage: storage,
    limits: {
        // 2 mB max file size
        fileSize: 1024 * 1024 * 2
    },
    fileFilter: filter
};
