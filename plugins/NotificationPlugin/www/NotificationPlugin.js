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
    
exports.changeLoginStatus = function (arg0, success, error) {
    exec(success, error, 'NotificationPlugin', 'changeLoginStatus', [arg0]);
};
