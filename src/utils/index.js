import * as CryptoJS from 'crypto-js';

/**
 * md5加密
 */
function encryptByDESModeECB(message) {

    let keyHex = CryptoJS.enc.Utf8.parse('login');

    let encrypted = CryptoJS.TripleDES.encrypt(message, keyHex, {
            mode: CryptoJS.mode.ECB,
            padding: CryptoJS.pad.Pkcs7
        }
    );
    let encryptedHexStr = CryptoJS.enc.Hex.parse(encrypted.ciphertext.toString());
    let encryptedBase64Str = CryptoJS.enc.Base64.stringify(encryptedHexStr);
    return encryptedBase64Str;
}


/**
 * 解密
 */
function decryptByDESModeEBC(cipherText) {

    let keyHex = CryptoJS.enc.Utf8.parse('login');

    cipherText = cipherText.replace(/\_/g, '/');
    cipherText = cipherText.replace(/\-/g, '+');

    let decrypted = CryptoJS.TripleDES.decrypt({
        iv: '',
        salt: '',
        ciphertext: CryptoJS.enc.Base64.parse(cipherText)
    }, keyHex, {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });
    return decrypted.toString(CryptoJS.enc.Utf8);
}

/**
 * 深拷贝
 */
function copyData (val) {
    if (!val) return;
    return JSON.parse(JSON.stringify(val));
}

/**
 * 去抖
 */
function debounce(func, delay) {
    let timer;
    return function (...args) {
        if (timer) {
            clearTimeout(timer)
        }
        timer = setTimeout(() => {
            func.apply(this, args)
        }, delay)
    }
}

export {
    encryptByDESModeECB,
    decryptByDESModeEBC,
    copyData,
    debounce,
}