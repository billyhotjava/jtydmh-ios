(function () {
  if (window.ZTNAWebSocketProxy) {
    console.error("already load ZTNAWebSocketProxy");
    return;
  }

  console.log("load ZTNAWebSocketProxy");
  if (!window.WebSocket) {
    throw Error("no WebSocket avaibale");
  }

  class ZTNAWebSocket {
    // constants
    static get CONNECTING() {
      return 0;
    }
    static get OPEN() {
      return 1;
    }
    static get CLOSING() {
      return 2;
    }
    static get CLOSED() {
      return 3;
    }

    constructor(url, protocols) {
      // WebSocket
      this.url = url;
      this.binaryType = "blob";
      this.bufferedAmount = 0;
      this.protocol = "";
      this.extensions = "";
      this.readyState = ZTNAWebSocket.CONNECTING;

      // custom
      this._uniqueId = "";
      this.listeners = {};
      this._open(url, protocols);
    }

    get CONNECTING() {
      return ZTNAWebSocket.CONNECTING;
    }
    get OPEN() {
      return ZTNAWebSocket.OPEN;
    }
    get CLOSING() {
      return ZTNAWebSocket.CLOSING;
    }
    get CLOSED() {
      return ZTNAWebSocket.CLOSED;
    }

    _open(url, protocols) {
      if (typeof protocols == "string") {
        protocols = [protocols];
      }
      this.readyState == ZTNAWebSocket.CONNECTING;

      this._uniqueId = window.ZTNAWebSocketProxy.onCallOpen(
        this,
        url,
        protocols,
        window.origin
      );
    }

    send(data) {
      var that = this;
      var sendBlock = function (type, data, length) {
        that.bufferedAmount += length;
        if (that.readyState != ZTNAWebSocket.OPEN) {
          return;
        }
        window.ZTNAWebSocketProxy.onCallSend(
          that._uniqueId,
          type,
          data,
          length
        );
      };

      if (typeof data == "string") {
        sendBlock("string", data, data.length);
      } else if (typeof data == "object") {
        if (data instanceof ArrayBuffer) data = new Blob([data]);
        if (data instanceof Blob) {
          const reader = new FileReader();
          reader.onload = function () {
            sendBlock("binary", reader.result.split(",")[1], data.size);
          };
          reader.readAsDataURL(data);
        }
      }
    }

    close(code, reason) {
      if (
        this.readyState == ZTNAWebSocket.CLOSING ||
        this.readyState == ZTNAWebSocket.CLOSED
      )
        return;
      this.readyState == ZTNAWebSocket.CLOSING;
      window.ZTNAWebSocketProxy.onCallClose(this._uniqueId, code, reason);
    }
  }

  ZTNAWebSocket.prototype.listeners = null;
  ZTNAWebSocket.prototype.onopen = null;
  ZTNAWebSocket.prototype.onmessage = null;
  ZTNAWebSocket.prototype.onclose = null;
  ZTNAWebSocket.prototype.onerror = null;

  ZTNAWebSocket.prototype.addEventListener = function (type, callback) {
    if (!(type in this.listeners)) {
      this.listeners[type] = [];
    }
    this.listeners[type].push(callback);
  };

  ZTNAWebSocket.prototype.removeEventListener = function (type, callback) {
    if (!(type in this.listeners)) {
      return;
    }
    var stack = this.listeners[type];
    for (var i = 0, l = stack.length; i < l; i++) {
      if (stack[i] === callback) {
        stack.splice(i, 1);
        return this.removeEventListener(type, callback);
      }
    }
  };

  ZTNAWebSocket.prototype.dispatchEvent = function (event) {
    if (!(event.type in this.listeners)) {
      return;
    }
    var stack = this.listeners[event.type];

    Object.defineProperty(event, "target", {
      value: this,
      writable: false,
    });
    for (var i = 0, l = stack.length; i < l; i++) {
      stack[i].call(this, event);
    }
  };

  window.ZTNAWebSocketProxy = {
    dispatchNativeEvents: dispatchNativeEvents,
    onCallOpen: onCallOpen,
    onCallSend: onCallSend,
    onCallClose: onCallClose,
  };

  var webSockets = {};
  const Promptkey = "WebSocketProxy";

  function onCallOpen(websocket, url, protocols, origin) {
    var event = {
      title: "open",
      content: {
        url: url,
        protocols: protocols,
        origin: origin,
      },
    };

    var uniqueId = _sendEvent(event);

    if (uniqueId) {
      _addWebSocket(uniqueId, websocket);
    }
    return uniqueId;
  }

  function onCallSend(uniqueId, type, data, length) {
    var event = {
      title: "send",
      content: {
        uniqueId: uniqueId,
        type: type,
        data: data,
        //length : length
      },
    };
    _sendEvent(event);
  }

  function onCallClose(uniqueId, code, reason) {
    var event = {
      title: "close",
      content: {
        uniqueId: uniqueId,
        code: code ? code : 1005,

        reason: reason ? reason : "",
      },
    };
    _sendEvent(event);
  }

  window.addEventListener("message", function (event) {
    var data = event.data;
    if (data && typeof data == "object" && data.flag == Promptkey) {
      dispatchNativeEvents(data);
    }
  });

  function dispatchNativeEvents(event) {
    console.log("dispatch native event");
    console.log(event);
    var content = event.content;
    var uniqueId = content.uniqueId;

    if (!_existWebSocket(uniqueId)) {
      //添加标记
      event.flag = Promptkey;
      var frames = window.frames;
      for (i = 0; i < frames.length; i++) {
        frames[i].postMessage(event, "*");
      }
      return;
    } else {
      _handleNativeEvents(event);
    }
  }

  function _handleNativeEvents(event) {
    console.log("handle native event");
    console.log(event);
    var title = event.title;
    var content = event.content;
    var uniqueId = content.uniqueId;

    if (!_existWebSocket(uniqueId)) return;

    switch (title) {
      case "onopen":
        _handleOnOpenEvent(uniqueId, content.protocol, content.extensions);
        break;
      case "onclose":
        _handleOnCloseEvent(uniqueId, content.code, content.reason);
        break;
      case "onmessage":
        _handleOnMessageEvent(uniqueId, content.type, content.data);
        break;
      case "onerror":
        _handleOnErrorEvent(uniqueId, content.code, content.message);
        break;
      case "bufferedAmount":
        _handleBufferedAmount(uniqueId, content.value);
        break;
      default:
        console.error("native event title invalid!", title);
    }
  }

  function _sendEvent(event) {
    var json = JSON.stringify(event);

    return window.prompt(Promptkey, json);
  }

  function _webSocketForUniqueId(uniqueId) {
    return webSockets[uniqueId];
  }

  function _addWebSocket(uniqueId, websocket) {
    webSockets[uniqueId] = websocket;
  }

  function _removeWebSocket(uniqueId) {
    delete webSockets[uniqueId];
  }

  function _existWebSocket(uniqueId) {
    if (webSockets[uniqueId]) {
      return true;
    }
    return false;
  }

  function _handleOnOpenEvent(uniqueId, protocol, extensions) {
    var msg =
      "_handleOnOpenEvent88:" +
      ";uniqueId:" +
      uniqueId +
      ";protocol:" +
      protocol +
      ";extensions:" +
      extensions;
    console.log(msg);

    var websocket = _webSocketForUniqueId(uniqueId);

    websocket.protocol = protocol;

    websocket.extensions = extensions;

    websocket.readyState = ZTNAWebSocket.OPEN;

    var openEvent = new Event("open");
    websocket.dispatchEvent(openEvent);
    if (websocket.onopen) {
      websocket.onopen(openEvent);
    }
  }

  function _handleOnCloseEvent(uniqueId, code, reason) {
    var websocket = _webSocketForUniqueId(uniqueId);

    websocket.readyState = ZTNAWebSocket.CLOSED;
    var closeEvent = new CloseEvent("close", {
      code: code,
      reason: reason,
      wasClean: true, //表示连接是否完全关闭，简单处理
    });
    websocket.dispatchEvent(closeEvent);
    if (websocket.onclose) {
      websocket.onclose(closeEvent);
    }
    // clean websocket
    _removeWebSocket(uniqueId);
  }

  function _handleOnMessageEvent(uniqueId, type, data) {
    var websocket = _webSocketForUniqueId(uniqueId);
    var msg =
      "_handleOnMessageEvent88:" +
      ";uniqueId:" +
      uniqueId +
      ";type:" +
      type +
      ";data:" +
      data;
    console.log(msg);

    var dispatchBlock = function (ret) {
      var messageEvent = new MessageEvent("message", {
        data: ret,
      });
      websocket.dispatchEvent(messageEvent);
      if (websocket.onmessage) {
        websocket.onmessage(messageEvent);
      }
    };

    if (type == "string") {
      dispatchBlock(data);
    } else {
      data = _base64ToBlob(data);
      if (websocket.binaryType == "arraybuffer") {
        const reader = new FileReader();
        reader.onload = function () {
          dispatchBlock(reader.result);
        };
        reader.readAsArrayBuffer(data);
      } else if (websocket.binaryType == "blob") {
        dispatchBlock(data);
      }
    }
  }

  function _handleOnErrorEvent(uniqueId, code, message) {
    var websocket = _webSocketForUniqueId(uniqueId);
    var errorEvent = new Event("error");
    websocket.dispatchEvent(errorEvent);
    if (websocket.onerror) {
      websocket.onerror(errorEvent);
    }
  }

  function _handleBufferedAmount(uniqueId, value) {
    var websocket = _webSocketForUniqueId(uniqueId);
    // set bufferedAmount
    websocket.bufferedAmount = 0;
  }

  function _base64ToBlob(base64Str) {
    var rawData = atob(base64Str);
    var array = new Uint8Array(rawData.length);
    for (var i = 0; i < rawData.length; i++) {
      array[i] = rawData.charCodeAt(i);
    }
    return new Blob([array]);
  }

  window.ZTNAWebSocketProxy.RealWebSocket = WebSocket;
  window.ZTNAWebSocket = ZTNAWebSocket;

  // WebSocket hook
  WebSocket = function (h, proto) {
    //     if (h.startsWith("ws://")) {
    //       return new window.ZTNAWebSocketProxy.RealWebSocket("ws://127.0.0.1:%d/param?host=" + h, proto);
    //     }
    return new window.ZTNAWebSocket(h, proto);
  };
  WebSocket.CONNECTING = 0;
  WebSocket.OPEN = 1;
  WebSocket.CLOSING = 2;
  WebSocket.CLOSED = 3;

  console.log("complete load ZTNAWebSocketProxy");
})();
