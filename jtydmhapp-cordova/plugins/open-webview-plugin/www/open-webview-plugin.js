var exec = require('cordova/exec');

exports.openWebView = function (url, title, info, colorString, success, error) {
    exec(success, error, 'OpenWebViewPlugin', 'openWebView', [url, title, info, colorString]);
};

exports.openWKWebView = function (url, title, colorString, success, error) {
    exec(success, error, 'OpenWebViewPlugin', 'openWKWebView', [url, title, colorString]);
};

exports.openFile = function (fileUrl, fileName, info, success, error) {
    exec(success, error, 'OpenWebViewPlugin', 'openFile', [fileUrl, fileName, info]);
};
