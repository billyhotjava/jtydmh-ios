(function () {
  if (window.qaxSDK) {
    return;
  }
  if (!window.onerror) {
    window.onerror = function (msg, url, line) {
      log("ERROR: " + msg + "@" + url + ":" + line);
    };
  }
  console.log("load qaxSDK js...");
  window.qaxSDK = {
    //        startPassWordAuth: startPassWordAuth,
    //        startTicketAuth: startTicketAuth,
    //        logout: logout,
    //        registerZTNAAuthResultListener: registerZTNAAuthResultListener,
    //        registerLogoutListener: registerLogoutListener,
    notifyClientOnline: notifyClientOnline,
    getMobileCommonInfo: getMobileCommonInfo,
    setMobileCommonInfo: setMobileCommonInfo,
  };

  /**
   * 开启账号密码认证
   * @param url 链接地址
   * @param userName 用户名
   * @param passWord 密码
   */
  function startPassWordAuth(url, userName, passWord) {
    var data = { url: url, userName: userName, passWord: passWord };
    window.qaxSDKBridge.callHandler("startPassWordAuth", data);
  }

  /**
   * 开启免密认证
   */
  function startTicketAuth() {
    window.qaxSDKBridge.callHandler("startPassWordAuth");
  }

  /**
   * 注销
   */
  function logout() {
    window.qaxSDKBridge.callHandler("logout");
  }

  /**
   * 注册认证监听
   * @param onAuthSuccessHandler
   * @param onAuthFailedHandler
   * @param onAuthProgressHandler
   */
  function registerZTNAAuthResultListener(
    onAuthSuccessHandler,
    onAuthFailedHandler,
    onAuthProgressHandler
  ) {
    window.qaxSDKBridge.registerHandler("onAuthSuccess", onAuthSuccessHandler);
    window.qaxSDKBridge.registerHandler("onAuthFailed", onAuthFailedHandler);
    window.qaxSDKBridge.registerHandler(
      "onAuthProgressed",
      onAuthProgressHandler
    );
  }

  /**
   * 注册注销监听
   * @param onLogoutHandler
   */
  function registerLogoutListener(onLogoutHandler) {
    window.qaxSDKBridge.registerHandler("onLogout", onLogoutHandler);
  }

  /**
   * 页面通知Native层上线
   * @param selectLine 选路地址
   * @param userName 用户名
   * @param guid 设备ID
   * @param qaxid qaxID
   */
  function notifyClientOnline(data) {
    window.qaxSDKBridge.callHandler("notifyClientOnline", data);
  }

  /**
   * 获取移动端应用相关信息
   * @param callBack 数据会通过callBack回调
   * eg: {"appName":"HostAppDemo","lang":"zh-CN","mobileId":"03538472b78840b15b13e83793e63a08","platform":"Android","platformVersion":"10","sdkVersion":"2.2.0.3.1"}
   */
  function getMobileCommonInfo(callBack) {
    return window.qaxSDKBridge.callHandler(
      "getMobileCommonInfo",
      null,
      callBack
    );
  }

  /**
   * 设置移动端相关信息
   * @param data AuthServerInfo
   */
  function setMobileCommonInfo(data) {
    window.qaxSDKBridge.callHandler("setMobileCommonInfo", data);
  }

  //发送bridge完成事件
  var sdk = window.qaxSDK;
  var doc = document;
  var readyEvent = doc.createEvent("Events");
  readyEvent.initEvent("qaxSDKReady");
  readyEvent.sdk = sdk;
  doc.dispatchEvent(readyEvent);
})();
