cordova.define("cordova-plugin-net-check.cordova-plugin-net-check", function(require, exports, module) {
var exec = require('cordova/exec');

exports.netType = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'netType');
};
exports.check = function (isLogin,userName,passWord,success, error) {
    exec(success, error, 'NetworkPlugin', 'check',[isLogin,userName,passWord]);
};
exports.checkout = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'checkout');
};
exports.access = function (deviceType,uniqueCode,userCode,success, error) {
    exec(success, error, 'NetworkPlugin', 'access',[deviceType,uniqueCode,userCode]);
};
exports.checkNetworkAvailable = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'checkNetworkAvailable');
};
exports.checkNetworkDialog = function (dialogStr,success, error) {
    exec(success, error, 'NetworkPlugin', 'checkNetworkDialog',[dialogStr]);
};
exports.openNC = function (success, error) {
    exec(success, error, 'NetworkPlugin', 'openNC',[]);
};
exports.openVideo = function (data,success, error) {
    exec(success, error, 'NetworkPlugin', 'openVideo',[data]);
};
});
