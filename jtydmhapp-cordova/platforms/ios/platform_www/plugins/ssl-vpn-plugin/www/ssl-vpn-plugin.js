cordova.define("ssl-vpn-plugin.ssl-vpn-plugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.loginVPN = function (arg0, arg1, arg2, arg3, arg4, success, error) {
    exec(success, error, 'SSLVPNPlugin', 'loginVPN', [arg0, arg1, arg2, arg3, arg4]);
};

exports.logoutVPN = function (success, error) {
    exec(success, error, 'SSLVPNPlugin', 'logoutVPN');
};

});
