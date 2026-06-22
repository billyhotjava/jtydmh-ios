cordova.define("cordova-plugin-imagepicker.ImagePicker", function(require, exports, module) {
/**
 * Created by zhongpeng on 2017/5/31.
 */
var exec = require('cordova/exec');

if (typeof Object.assign != 'function') {
    Object.assign = function (target) {
        'use strict';
        if (target == null) {
            throw new TypeError('Cannot convert undefined or null to object');
        }

        target = Object(target);
        for (var index = 1; index < arguments.length; index++) {
            var source = arguments[index];
            if (source != null) {
                for (var key in source) {
                    if (Object.prototype.hasOwnProperty.call(source, key)) {
                        target[key] = source[key];
                    }
                }
            }
        }

        return target;
    };
}

var defaults = {
    maximumImagesCount: 4,
    width: -1, // negative value means auto scale
    height: -1,
    quality: 80,
    enablePickOriginal: false,
    
};

var transformResult = function(result) {
    if(result && result.images) {
        var i, img;
        for(i = 0; i < result.images.length; i++) {
            img = result.images[i];
            if(img && img.path) {
                img.uri = 'file://' + img.path;
            }
        }
    }
};

module.exports = {
    /**
     * 获取图片地址
     * @param onSuccess
     * @param onFail
     * @param params
     */
    getPictures: function (onSuccess, onFail, params) {
        var options = Object.assign({}, defaults, params);
        
        var success = function(result) {
            if(typeof onSuccess == 'function') {
                transformResult(result);
                onSuccess.apply(null, arguments);
            }
        };

        exec(success, onFail, 'ImagePicker', 'getPictures', [options]);
    },
    /**
     * 拍照
     * @param onSuccess
     * @param onFail
     * @param params
     */
    takePhoto: function (onSuccess, onFail, params) {
        var options = Object.assign({}, defaults, params);
        
        var success = function(result) {
            if(typeof onSuccess == 'function') {
                transformResult(result);
                onSuccess.apply(null, arguments);
            }
        };

        exec(success, onFail, 'ImagePicker', 'takePhoto', [options]);
    },
offlineToLocal: function (onSuccess, onFail, fileInfo) {
    var success = function(result) {
        if(typeof onSuccess == 'function') {
            transformResult(result);
            onSuccess.apply(null, arguments);
        }
    };
    exec(onSuccess, onFail, 'ImagePicker', 'offlineToLocal', [fileInfo]);
    },
uploadOfflineDataRemoveLocalData: function (onSuccess, onFail, fileInfo) {
    var success = function(result) {
        if(typeof onSuccess == 'function') {
            transformResult(result);
            onSuccess.apply(null, arguments);
        }
    };
    exec(onSuccess, onFail, 'ImagePicker', 'uploadOfflineDataRemoveLocalData', [fileInfo]);
    },
playMedia: function(onSuccess, onFail, playUrl) {
    var success = function(result) {
        if(typeof onSuccess == 'function') {
            transformResult(result);
            onSuccess.apply(null, arguments);
        }
    };
    exec(onSuccess, onFail, 'ImagePicker', 'playMedia', [playUrl]);
},
uploadFiles: function(onSuccess, onFail, uploadInfo) {
    var success = function(result) {
        if(typeof onSuccess == 'function') {
            transformResult(result);
            onSuccess.apply(null, arguments);
        }
    };
    exec(onSuccess, onFail, 'ImagePicker', 'uploadFiles', [uploadInfo]);
},
};

});
