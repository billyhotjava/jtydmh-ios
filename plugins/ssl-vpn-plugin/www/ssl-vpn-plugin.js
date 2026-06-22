var exec = require('cordova/exec');

exports.loginVPN = function (mVPNHost,mVPNPort,mVPNAuth,mVPNUserName,mVPNPassWord,success,error) {
    exec(success,error,'SSLVPNPlugin', 'loginVPN', [mVPNHost,mVPNPort,mVPNAuth,mVPNUserName,mVPNPassWord]);
};

exports.logoutVPN = function (success,error) {
    exec(success,error,'SSLVPNPlugin', 'logoutVPN');
};