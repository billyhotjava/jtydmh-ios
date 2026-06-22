var exec = require('cordova/exec');

exports.netType = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'netType');
};

exports.access = function (deviceType, uniqueCode, userCode, success, error) {
    exec(success, error, 'NetworkPlugin', 'access', [deviceType, uniqueCode, userCode]);
};

exports.update = function (deviceType, hasDialog, success, error) {
    exec(success, error, 'NetworkPlugin', 'update', [deviceType, hasDialog]);
};

exports.checkNetworkAvailable = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'checkNetworkAvailable');
};

exports.checkNetworkDialog = function (dialogStr, success, error) {
    exec(success, error, 'NetworkPlugin', 'checkNetworkDialog', [dialogStr]);
};
