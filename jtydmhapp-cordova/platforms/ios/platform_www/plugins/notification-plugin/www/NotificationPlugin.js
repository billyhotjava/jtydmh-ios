cordova.define("notification-plugin.NotificationPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.registerNotification = function (success, error) {
    exec(success, error, 'NotificationPlugin', 'registerNotification');
};

exports.sendNotification = function (arg0, arg1, arg2, success, error) {
    exec(success, error, 'NotificationPlugin', 'sendNotification', [arg0, arg1, arg2]);
};

exports.didReceiveRemoteNotification = function (success, error) {
    exec(success, error, 'NotificationPlugin', 'didReceiveRemoteNotification');
};
    
exports.changeLoginStatus = function (loginStatus, vpnAccount, vpnPassword, guoShenAccessToken, userName, phoneNumber, success, error) {
    exec(success, error, 'NotificationPlugin', 'changeLoginStatus', [loginStatus, vpnAccount, vpnPassword, guoShenAccessToken, userName, phoneNumber]);
};

exports.applicationDidBecomeActiveShouldGestureVerify = function (success, error) {
    exec(success, error, 'NotificationPlugin', 'applicationDidBecomeActiveShouldGestureVerify');
};

exports.resetGestureVerifyTime = function (success, error) {
    exec(success, error, 'NotificationPlugin', 'resetGestureVerifyTime');
};

exports.nativeToVueTransmitMessages = function (success, error) {
    exec(success, error, 'NotificationPlugin', 'nativeToVueTransmitMessages');
};

});
