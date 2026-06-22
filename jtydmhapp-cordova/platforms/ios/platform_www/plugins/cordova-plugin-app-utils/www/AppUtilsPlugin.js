cordova.define("cordova-plugin-app-utils.AppUtilsPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.registrationId = function (success, error) {
    exec(success, error, 'AppUtilsPlugin', 'registrationId');
};

exports.clearCache = function (success, error) {
    exec(success, error, 'AppUtilsPlugin', 'clearCache');
};

exports.setWebSize = function (arg0, success, error) {
    exec(success, error, 'AppUtilsPlugin', 'setWebSize', [arg0]);
};

exports.exitApp = function (success, error) {
    exec(success, error, 'AppUtilsPlugin', 'exitApp');
};

});
