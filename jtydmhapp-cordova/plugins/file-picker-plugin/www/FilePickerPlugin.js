var exec = require('cordova/exec');

exports.file = function (success, error) {
    exec(success, error, 'FilePickerPlugin', 'file');
};
