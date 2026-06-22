cordova.define("file-picker-plugin.FilePickerPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.file = function (success, error) {
    exec(success, error, 'FilePickerPlugin', 'file');
};

});
