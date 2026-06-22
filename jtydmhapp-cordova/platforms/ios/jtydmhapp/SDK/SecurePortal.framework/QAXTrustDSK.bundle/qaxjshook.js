var __awaiter =
  (this && this.__awaiter) ||
  function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
      function fulfilled(value) {
        try {
          step(generator.next(value));
        } catch (e) {
          reject(e);
        }
      }
      function rejected(value) {
        try {
          step(generator["throw"](value));
        } catch (e) {
          reject(e);
        }
      }
      function step(result) {
        result.done
          ? resolve(result.value)
          : new P(function (resolve) {
              resolve(result.value);
            }).then(fulfilled, rejected);
      }
      step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
  };
var __generator =
  (this && this.__generator) ||
  function (thisArg, body) {
    var _ = {
        label: 0,
        sent: function () {
          if (t[0] & 1) throw t[1];
          return t[1];
        },
        trys: [],
        ops: [],
      },
      f,
      y,
      t,
      g;
    return (
      (g = { next: verb(0), throw: verb(1), return: verb(2) }),
      typeof Symbol === "function" &&
        (g[Symbol.iterator] = function () {
          return this;
        }),
      g
    );
    function verb(n) {
      return function (v) {
        return step([n, v]);
      };
    }
    function step(op) {
      if (f) throw new TypeError("Generator is already executing.");
      while (_)
        try {
          if (
            ((f = 1),
            y &&
              (t =
                op[0] & 2
                  ? y["return"]
                  : op[0]
                  ? y["throw"] || ((t = y["return"]) && t.call(y), 0)
                  : y.next) &&
              !(t = t.call(y, op[1])).done)
          )
            return t;
          if (((y = 0), t)) op = [op[0] & 2, t.value];
          switch (op[0]) {
            case 0:
            case 1:
              t = op;
              break;
            case 4:
              _.label++;

              return { value: op[1], done: false };
            case 5:
              _.label++;
              y = op[1];
              op = [0];
              continue;
            case 7:
              op = _.ops.pop();
              _.trys.pop();
              continue;
            default:
              if (
                !((t = _.trys), (t = t.length > 0 && t[t.length - 1])) &&
                (op[0] === 6 || op[0] === 2)
              ) {
                _ = 0;
                continue;
              }
              if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) {
                _.label = op[1];
                break;
              }
              if (op[0] === 6 && _.label < t[1]) {
                _.label = t[1];
                t = op;
                break;
              }
              if (t && _.label < t[2]) {
                _.label = t[2];
                _.ops.push(op);
                break;
              }
              if (t[2]) _.ops.pop();
              _.trys.pop();
              continue;
          }
          op = body.call(thisArg, _);
        } catch (e) {
          op = [6, e];
          y = 0;
        } finally {
          f = t = 0;
        }
      if (op[0] & 5) throw op[1];
      return { value: op[0] ? op[1] : void 0, done: true };
    }
  };
var __values =
  (this && this.__values) ||
  function (o) {
    var m = typeof Symbol === "function" && o[Symbol.iterator],
      i = 0;
    if (m) return m.call(o);
    return {
      next: function () {
        if (o && i >= o.length) o = void 0;
        return { value: o && o[i++], done: !o };
      },
    };
  };

(function (window) {
  var sendLogToOC = function (txt) {
    try {
    } catch (e) {}
  };
  let ztna_interceptors = [];

  function interceptor(fetch, ...args) {
    const reversedInterceptors = ztna_interceptors.reduce(
      (array, interceptor) => [interceptor].concat(array),
      []
    );
    let promise = Promise.resolve(args);

    reversedInterceptors.forEach(({ request, requestError }) => {
      if (request || requestError) {
        promise = promise.then((args) => request(...args), requestError);
      }
    });

    promise = promise.then((args) => fetch(...args));

    reversedInterceptors.forEach(({ response, responseError }) => {
      if (response || responseError) {
        promise = promise.then(response, responseError);
      }
    });

    return promise;
  }

  function ztna_Hook_fetch(env) {
    if (!env.fetch) {
      try {
        require("whatwg-fetch");
      } catch (err) {
        throw Error("No fetch avaibale. Unable to register fetch-intercept");
      }
    }
    env.fetch = (function (fetch) {
      return function (...args) {
        return interceptor(fetch, ...args);
      };
    })(env.fetch);

    return {
      register: function (interceptor) {
        ztna_interceptors.push(interceptor);
        return () => {
          const index = ztna_interceptors.indexOf(interceptor);
          if (index >= 0) {
            ztna_interceptors.splice(index, 1);
          }
        };
      },
      clear: function () {
        ztna_interceptors = [];
      },
    };
  }

  /**
   * Hook FormData，由于低版本的 FormData 没有支持 entries() 等遍历 api，所以只是在 ajax send 里遍历，是无法获取到具体的值的，
   * 所以针对低版本的 iOS 系统做 Hook FormData 处理,hook append函数（可以支持完全js创建的formData场景），hook FormData的构造函数可以支持HTML形式的FormData。
   */
  function ztna_hookFormData() {
    /**
     * 解析HTML的form DOM，获取其中的子对象的key value
     * @param {*} box 输入的HTML DOM
     * @param {*} outDict 输出的字典，FormData的key,value
     */
    function ztna_scanDOM(box, outDict) {
      var eles = Array.from(box.children);
      for (var ele of eles) {
        if (
          ele.children.length &&
          ele.nodeName !== "SELECT" &&
          ele.nodeName !== "FIELDSET"
        ) {
          ztna_scanDOM(ele);
        } else {
          var nodeName = ele.nodeName.toLowerCase();
          var formElementp = function (v) {
            return (
              v === "input" ||
              v === "select" ||
              v === "textarea" ||
              v === "fieldset"
            );
          };
          if (formElementp(nodeName)) {
            if (ele.disabled === true) continue;
            var k, v;
            k = ele.name;
            if (!k) continue;
            if (ele.type === "radio") {
              if (!ele.checked) continue;
              v = ele.value;
            } else if (ele.type === "checkbox") {
              if (!ele.checked) continue;
              v = ele.value;
            } else {
              if (nodeName === "select" && ele.multiple) {
                var vs = [];
                var options = toArray(ele.children);
                for (var o of options) {
                  vs.push(o.value);
                }
                v = vs;
              } else if (nodeName === "fieldset") {
                ztna_scanDOM(ele);
              } else {
                v = ele.value;
              }
            }
            if (v === undefined) continue;
            var alive = k in outDict;
            if (alive) {
              var ov = outDict[k];
              if (
                Object.prototype.toString.call(outDict[k]) === "[object Array]"
              ) {
                outDict[k] = ov.concat(v);
              } else {
                outDict[k] = [ov, v];
              }
            } else {
              outDict[k] = v;
            }
          }
        }
      }
    }

    var ztna_originAppend = window.FormData.prototype["append"];
    var ztna_originEntries = window.FormData.prototype["entries"];

    if (!ztna_originEntries) {
      if (!window.ztna_oriFormData) {
        window.FormData.prototype["append"] = function () {
          if (!this._entries) {
            this._entries = [];
          }
          this._entries.push(arguments);
          return ztna_originAppend.apply(this, arguments);
        };

        window.ztna_oriFormData = window.FormData;

        window.FormData = function (box) {
          var ret = new window.ztna_oriFormData(box);
          try {
            if (box) {
              var outDict = {};
              ztna_scanDOM(box, outDict);
              if (!ret._entries) {
                ret._entries = [];
              }
              sendLogToOC("parse FormData constructor params:" + outDict);
              for (var key in outDict) {
                ret._entries.push([key, outDict[key]]);
              }
            }
          } catch (e) {
            sendLogToOC("formData to Json error : " + e.message);
          }

          return ret;
        };
      }
      sendLogToOC("hook FormData OK");
    } else {
      sendLogToOC("no need hook FormData");
    }
  }

  var events = [
    "load",
    "loadend",
    "timeout",
    "error",
    "readystatechange",
    "abort",
  ];

  function configEvent(event, xhrProxy) {
    var e = {};
    for (var attr in event) e[attr] = event[attr];

    e.target = e.currentTarget = xhrProxy;
    return e;
  }

  function ztna_initHookAjaxMethod(ob) {
    var realXhr = "ZTNARealXMLHttpRequest";

    ob.ztna_HookAjax = function (proxy) {
      window[realXhr] = window[realXhr] || XMLHttpRequest;

      XMLHttpRequest = function () {
        var ztna_xhr = new window[realXhr]();

        for (var attr in ztna_xhr) {
          var type = "";
          try {
            type = typeof ztna_xhr[attr];
          } catch (e) {}
          if (type === "function") {
            this[attr] = hookFunction(attr);
          } else {
            Object.defineProperty(this, attr, {
              get: getterFactory(attr),
              set: setterFactory(attr),
              enumerable: true,
              configurable: true,
            });
          }
        }
        this.ztna_xhr = ztna_xhr;
      };

      Object.defineProperty(XMLHttpRequest, "prototype", {
        value: window[realXhr].prototype,
      });

      function getterFactory(attr) {
        return function () {
          var v = this.hasOwnProperty(attr + "_")
            ? this[attr + "_"]
            : this.ztna_xhr[attr];
          var attrGetterHook = (proxy[attr] || {})["getter"];
          return (attrGetterHook && attrGetterHook(v, this)) || v;
        };
      }

      function setterFactory(attr) {
        return function (v) {
          var ztna_xhr = this.ztna_xhr;
          var that = this;
          var hook = proxy[attr];

          if (attr.substring(0, 2) === "on") {
            that[attr + "_"] = v;
            ztna_xhr[attr] = function (e) {
              e = configEvent(e, that);
              var ret = proxy[attr] && proxy[attr].call(that, ztna_xhr, e);
              ret || v.call(that, e);
            };
          } else {
            var attrSetterHook = (hook || {})["setter"];
            v = (attrSetterHook && attrSetterHook(v, that)) || v;
            try {
              ztna_xhr[attr] = v;
            } catch (e) {
              this[attr + "_"] = v;
            }
          }
        };
      }

      function hookFunction(fun) {
        return function () {
          var args = [].slice.call(arguments);

          if (proxy[fun]) {
            var proxyRet = proxy[fun].call(this, args, this.ztna_xhr);
            if (proxyRet && proxyRet !== 500) {
              if (typeof proxyRet === "boolean") {
                return;
              } else {
                return proxyRet;
              }
            }
          }
          if (fun === "send" && proxyRet === 500) {
            return new Promise(function (resolve, reject) {
              setTimeout(() => {
                resolve();
              }, proxyRet);
            }).then(() => {
              return this.ztna_xhr[fun].apply(this.ztna_xhr, args);
            });
          } else {
            return this.ztna_xhr[fun].apply(this.ztna_xhr, args);
          }
        };
      }

      return window[realXhr];
    };

    ob.ztna_unHookAjax = function () {
      if (window[realXhr]) XMLHttpRequest = window[realXhr];
      window[realXhr] = undefined;
    };

    ob["ztnadefault"] = ob;
  }

  var ZTNAJSBridgeUtil = /** @class */ (function () {
    function ZTNAJSBridgeUtil() {}
    ZTNAJSBridgeUtil.convertFormDataToJson = function (formData, callback) {
      var _this = this;
      var promise = new Promise(function (resolve, reject) {
        return __awaiter(_this, void 0, void 0, function () {
          var e_1,
            _a,
            formDataJson,
            formDataFileKeys,
            formDatas,
            i,
            pair,
            key,
            value,
            fileName,
            singleKeyValue,
            formDataFile,
            _b,
            _c,
            pair,
            key,
            value,
            singleKeyValue,
            formDataFile,
            e_1_1;
          return __generator(this, function (_d) {
            switch (_d.label) {
              case 0:
                formDataJson = {};
                formDataFileKeys = [];
                formDatas = [];
                if (!formData._entries) return [3 /*break*/, 7];
                i = 0;
                _d.label = 1;
              case 1:
                if (!(i < formData._entries.length)) return [3 /*break*/, 6];
                pair = formData._entries[i];
                key = pair[0];
                value = pair[1];
                fileName = pair.length > 2 ? pair[2] : null;
                singleKeyValue = [];
                singleKeyValue.push(key);
                if (!(value instanceof File || value instanceof Blob))
                  return [3 /*break*/, 3];
                return [4 /*yield*/, ZTNAJSBridgeUtil.convertFileToJson(value)];
              case 2:
                formDataFile = _d.sent();
                if (fileName) {
                  formDataFile.name = fileName;
                }
                singleKeyValue.push(formDataFile);
                formDataFileKeys.push(key);
                return [3 /*break*/, 4];
              case 3:
                /*ios11 webkit formdata append obj need to string */
                if (value) {
                  value = value.toString();
                }
                singleKeyValue.push(value);
                _d.label = 4;
              case 4:
                formDatas.push(singleKeyValue);
                _d.label = 5;
              case 5:
                i++;
                return [3 /*break*/, 1];
              case 6:
                return [3 /*break*/, 16];
              case 7:
                _d.trys.push([7, 14, 15, 16]);
                (_b = __values(formData.entries())), (_c = _b.next());
                _d.label = 8;
              case 8:
                if (!!_c.done) return [3 /*break*/, 13];
                pair = _c.value;
                key = pair[0];
                value = pair[1];
                singleKeyValue = [];
                singleKeyValue.push(key);
                if (!(value instanceof File || value instanceof Blob))
                  return [3 /*break*/, 10];

                return [4 /*yield*/, ZTNAJSBridgeUtil.convertFileToJson(value)];
              case 9:
                formDataFile = _d.sent();
                singleKeyValue.push(formDataFile);
                formDataFileKeys.push(key);
                return [3 /*break*/, 11];
              case 10:
                singleKeyValue.push(value);
                _d.label = 11;
              case 11:
                formDatas.push(singleKeyValue);
                _d.label = 12;
              case 12:
                _c = _b.next();
                return [3 /*break*/, 8];
              case 13:
                return [3 /*break*/, 16];
              case 14:
                e_1_1 = _d.sent();
                e_1 = { error: e_1_1 };
                return [3 /*break*/, 16];
              case 15:
                try {
                  if (_c && !_c.done && (_a = _b.return)) _a.call(_b);
                } finally {
                  if (e_1) throw e_1.error;
                }
                return [7 /*endfinally*/];
              case 16:
                formDataJson["fileKeys"] = formDataFileKeys;
                formDataJson["formData"] = formDatas;
                callback(formDataJson);
                resolve(formDataJson);
                return [2 /*return*/];
            }
          });
        });
      });

      promise
        .then(function (json) {})
        .catch(function (error) {
          sendLogToOC("formData to Json error : " + error);
        });
    };
    /**
     * 读取单个文件数据，并转成 base64，最后返回 json 对象
     * @param file
     */
    ZTNAJSBridgeUtil.convertFileToJson = function (file) {
      return new Promise(function (resolve, reject) {
        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function (ev) {
          var base64 = ev.target.result;
          var formDataFile = {
            name: file instanceof File ? file.name : "",
            lastModified: file instanceof File ? file.lastModified : 0,
            size: file.size,
            type: file.type,
            data: base64,
          };
          resolve(formDataFile);
          return null;
        };
        reader.onerror = function (ev) {
          reject(Error("formdata 表单读取文件数据失败"));
          return null;
        };
      });
    };

    ZTNAJSBridgeUtil.getIOSVersion = function (userAgent) {
      var ua = userAgent.toLowerCase();
      if (ua.indexOf("like mac os x") > 0) {
        var reg = /os [\d._]*/gi;
        var verinfo = ua.match(reg);
        var version = (verinfo + "")
          .replace(/[^0-9|_.]/gi, "")
          .replace(/_/gi, ".");
        var arr = version.split(".");
        if (arr[0]) {
          return parseInt(arr[0]);
        }
      }
      return 0;
    };

    return ZTNAJSBridgeUtil;
  })();

  var ztna_AjaxHookProxy = {
    readyState: {
      getter: function (v, xhr) {
        xhr = xhr.ztna_xhr;
        if (xhr.isSync && xhr.responseFromOC) {
          return xhr.responseFromOC.readyState;
        }
      },
    },
    status: {
      getter: function (v, xhr) {
        xhr = xhr.ztna_xhr;
        if (xhr.isSync && xhr.responseFromOC) {
          return xhr.responseFromOC.status;
        }
      },
    },
    statusText: {
      getter: function (v, xhr) {
        xhr = xhr.ztna_xhr;
        if (xhr.isSync && xhr.responseFromOC) {
          return xhr.responseFromOC.statusText;
        }
      },
    },
    responseText: {
      getter: function (v, xhr) {
        xhr = xhr.ztna_xhr;
        if (xhr.isSync && xhr.responseFromOC) {
          return xhr.responseFromOC.responseText;
        }
      },
    },
    response: {
      getter: function (v, xhr) {
        xhr = xhr.ztna_xhr;
        if (xhr.isSync && xhr.responseFromOC) {
          return xhr.responseFromOC.responseText;
        }
      },
    },
    addEventListener: function (args, xhr) {
      var _this = this;

      var that = _this;
      if (events.indexOf(args[0]) !== -1) {
        var handler = args[1];
        if (typeof handler != "function") {
          that = handler;
          handler = handler.handleEvent;
        }
        xhr.addEventListener(args[0], function (e) {
          var event = configEvent(e, _this);
          event.type = args[0];
          event.isTrusted = true;
          handler.call(that, event);
        });
        return true;
      }
    },

    open: function (arg, xhr) {
      try {
        var iosVersion = ZTNAJSBridgeUtil.getIOSVersion(navigator.userAgent);
        xhr.iosVersion = iosVersion;

        sendLogToOC(
          "open called: method:" +
            arg[0] +
            ", url:" +
            arg[1] +
            ", async:" +
            arg[2]
        );

        if (
          !(
            arg[0] == "GET" ||
            arg[0] == "get" ||
            arg[0] == "HEAD" ||
            arg[0] == "head"
          )
        ) {
          if (arg[2] != undefined && !arg[2] && iosVersion >= 15) {
            sendLogToOC("no need fixbody and fixSync");
            return false;
          }

          xhr.needFixDropBody = true;
          xhr.method = arg[0];
          xhr.uniqueID = Math.round(Math.random() * 10000000) + "";
          xhr.requestParamsToOC = {
            qax_ztnataskid: xhr.uniqueID,
            method: arg[0],
            url: arg[1],
            scheme: window.location.protocol,
            host: window.location.hostname,
            port: window.location.port,
          };
        }

        if (arg[2] != undefined && !arg[2] && iosVersion <= 12) {
          xhr.isSync = true;
          xhr.uniqueID = Math.round(Math.random() * 100000);
          xhr.requestParamsToOC = {
            taskID: xhr.uniqueID,
            method: arg[0],
            url: arg[1],
            scheme: window.location.protocol,
            host: window.location.hostname,
            port: window.location.port,
            href: window.location.href,
            referer:
              document.referrer != ""
                ? document.referrer
                : window.location.href,
            useragent: navigator.userAgent,
            async: arg[2],
            timeout: xhr.timeout,
          };
          return true;
        }
      } catch (e) {
        sendLogToOC("Except in hook open:" + e.message);
      }
    },
    send: function (arg, xhr) {
      try {
        if (xhr.isSync) {
          sendLogToOC("send called: params:" + arg[0]);
          sendLogToOC("uniqueID:" + xhr.uniqueID);
          var data = arg[0];

          if (data instanceof Uint8Array) {
            data = Array.from(data);
          } else {
            if (data) {
              data = data.toString();
            }
          }
          xhr.requestParamsToOC.sendBody = data;

          responseJsonStrFromOC = window.prompt(
            "FixAjaxSync",
            JSON.stringify(xhr.requestParamsToOC)
          );
          sendLogToOC("responseJsonStrFromOC:" + responseJsonStrFromOC);
          xhr.responseFromOC = JSON.parse(responseJsonStrFromOC);

          if (xhr.onreadystatechange) {
            xhr.onreadystatechange();
          }

          if (xhr.responseFromOC.readyState === xhr.DONE) {
            if (xhr.onload) {
              xhr.onload();
            }

            var load = document.createEvent("Events");
            load.initEvent("load");
            xhr.dispatchEvent(load);
          } else {
            if (xhr.onerror) {
              xhr.onerror();
            }

            var error = document.createEvent("Events");
            error.initEvent("error");
            xhr.dispatchEvent(error);
          }

          return true;
        } else if (xhr.needFixDropBody) {
          sendLogToOC("xhr send called: params:" + arg[0]);
          sendLogToOC("uniqueID:" + xhr.uniqueID);
          var data = arg[0];
          if (data) {
            if (data instanceof Uint8Array) {
              if (xhr.iosVersion && xhr.iosVersion < 12) {
                xhr.setRequestHeader(
                  "qax_ztnataskid",
                  xhr.requestParamsToOC.qax_ztnataskid
                );
                xhr.setRequestHeader(
                  "qax_ztnataskid_cors" + xhr.requestParamsToOC.qax_ztnataskid,
                  "1"
                );
                sendLogToOC("body data is Uint8Array...");

                data = Array.from(data);
                xhr.requestParamsToOC.data = data;
                window.prompt(
                  "FixDropBodyByte",
                  JSON.stringify(xhr.requestParamsToOC)
                );
                sendLogToOC("FixDropBodyByte.");
              }
            } else if (
              data instanceof FormData ||
              (window.ztna_oriFormData &&
                data instanceof window.ztna_oriFormData)
            ) {
              sendLogToOC("body data is FormData...");
              xhr.setRequestHeader(
                "qax_ztnataskid",
                xhr.requestParamsToOC.qax_ztnataskid
              );
              xhr.setRequestHeader(
                "qax_ztnataskid_cors" + xhr.requestParamsToOC.qax_ztnataskid,
                "1"
              );

              xhr.setRequestHeader("qax_isformdata", "1");
              ZTNAJSBridgeUtil.convertFormDataToJson(data, function (json) {
                sendLogToOC("parse formData json:" + JSON.stringify(json));
                xhr.requestParamsToOC.data = json;
                console.log("FormData");
                window.prompt(
                  "FixDropBodyFormData",
                  JSON.stringify(xhr.requestParamsToOC)
                );
              });

              return 500;
            } else if (data instanceof File || data instanceof Blob) {
              sendLogToOC("body data is File...");
              var form = new FormData();

              form.append("file", data);
              xhr.setRequestHeader(
                "qax_ztnataskid",
                xhr.requestParamsToOC.qax_ztnataskid
              );
              xhr.setRequestHeader(
                "qax_ztnataskid_cors" + xhr.requestParamsToOC.qax_ztnataskid,
                "1"
              );

              xhr.setRequestHeader("qax_isformdata", "1");
              ZTNAJSBridgeUtil.convertFormDataToJson(form, function (json) {
                sendLogToOC("parse formData json:" + JSON.stringify(json));
                xhr.requestParamsToOC.data = json;
                console.log("File");
                window.prompt(
                  "FixDropBodyFormData",
                  JSON.stringify(xhr.requestParamsToOC)
                );
              });
              return 500;
            } else {
              if (xhr.iosVersion && xhr.iosVersion < 12) {
                sendLogToOC("body data is Others such as String...");

                xhr.setRequestHeader(
                  "qax_ztnataskid",
                  xhr.requestParamsToOC.qax_ztnataskid
                );
                xhr.setRequestHeader(
                  "qax_ztnataskid_cors" + xhr.requestParamsToOC.qax_ztnataskid,
                  "1"
                );
                xhr.requestParamsToOC.sendBody = data.toString();
                console.log("other");
                window.prompt(
                  "FixDropBody4XHR",
                  JSON.stringify(xhr.requestParamsToOC)
                );
              }
            }
          }
        }
      } catch (e) {
        sendLogToOC("Except in hook send:" + e.message);
      }
    },

    setRequestHeader: function (arg, xhr) {
      try {
        if (xhr.isSync && xhr.requestParamsToOC && arg[0] && arg[1]) {
          sendLogToOC("setRequestHeader called:" + arg);
          if (!xhr.requestParamsToOC.requestHeader) {
            xhr.requestParamsToOC.requestHeader = new Object();
          }
          xhr.requestParamsToOC.requestHeader[arg[0]] = arg[1];
          return true;
        }
      } catch (e) {
        sendLogToOC("Except in hook setRequestHeader:" + e.message);
      }
    },
    overrideMimeType: function (arg, xhr) {
      try {
        if (xhr.isSync && xhr.requestParamsToOC && arg[0]) {
          sendLogToOC("overrideMimeType called:" + arg[0]);
          xhr.requestParamsToOC.overrideMimeType = arg[0];
          return true;
        }
      } catch (e) {
        sendLogToOC("Except in hook overrideMimeType:" + e.message);
      }
    },
    getAllResponseHeaders: function (arg, xhr) {
      try {
        if (xhr.isSync && xhr.responseFromOC && xhr.responseFromOC.headers) {
          sendLogToOC("hooked getAllResponseHeaders called");
          var strHeaders = "";
          for (var name_1 in xhr.responseFromOC.headers) {
            strHeaders +=
              name_1 + ": " + xhr.responseFromOC.headers[name_1] + "\r\n";
          }
          sendLogToOC("hooked getAllResponseHeaders:" + strHeaders);
          return strHeaders;
        }
      } catch (e) {
        sendLogToOC("Except in hook getAllResponseHeaders:" + e.message);
      }
    },
    getResponseHeader: function (arg, xhr) {
      try {
        if (
          xhr.isSync &&
          xhr.responseFromOC &&
          xhr.responseFromOC.headers &&
          arg[0]
        ) {
          sendLogToOC("hooked getResponseHeader called:" + arg[0]);
          var headerName = arg[0];
          var strHeaders = "";
          var upperCaseHeaderName = headerName.toUpperCase();
          for (var name_2 in xhr.responseFromOC.headers) {
            if (upperCaseHeaderName == name_2.toUpperCase())
              strHeaders = xhr.responseFromOC.headers[name_2];
          }
          sendLogToOC("hooked getResponseHeader:" + strHeaders);
          return strHeaders;
        }
      } catch (e) {
        sendLogToOC("Except in hook getResponseHeader:" + e.message);
      }
    },
  };

  var ztna_FetchHookProxy = {
    request: function (ori, config) {
      try {
        var url = "";
        var method = "GET";
        var headers = {};
        var body = "";

        if (ori instanceof Request) {
          url = ori.url;
          if (ori.method && config.method != "undefined") {
            method = ori.method;
          }
          if (ori.headers) {
            headers = ori.headers;
          }

          if (ori.body) {
            body = ori.body;
          }
        } else {
          url = ori;
        }

        if (config && config != "undefined") {
          if (config.method && config.method != "undefined") {
            method = config.method;
          }
          /*除了GET和HEAD都能携带body*/
          if (
            method == "GET" ||
            method == "get" ||
            method == "HEAD" ||
            method == "head"
          ) {
            return [url, config];
          }

          if (config.headers) {
            headers = config.headers;
          }

          if (config.body) {
            body = config.body;
          }
        }

        var uniqueID = Math.round(Math.random() * 10000000) + "";

        if (headers instanceof Headers) {
          headers.append("qax_ztnataskid", uniqueID);
          headers.append("qax_ztnataskid_cors" + uniqueID, "1");
        } else {
          headers["qax_ztnataskid"] = uniqueID;
          headers["qax_ztnataskid_cors" + uniqueID] = "1";
        }

        sendLogToOC("fetch url:" + url + ",method:" + method);

        var requestParamsToOC = {
          qax_ztnataskid: uniqueID,
          method: method,
          url: url,
          scheme: window.location.protocol,
          host: window.location.hostname,
          port: window.location.port,
        };

        if (body) {
          var iosVersion = ZTNAJSBridgeUtil.getIOSVersion(navigator.userAgent);
          if (body instanceof Uint8Array) {
            if (iosVersion && iosVersion < 12) {
              sendLogToOC("body data is Uint8Array...");

              body = Array.from(body);
              requestParamsToOC.data = body;
              window.prompt(
                "FixDropBodyByte",
                JSON.stringify(requestParamsToOC)
              );
              sendLogToOC("FixDropBodyByte.");
            }
          } else if (
            body instanceof FormData ||
            body instanceof Blob ||
            (window.ztna_oriFormData && body instanceof window.ztna_oriFormData)
          ) {
            console.log("FormDataFetch");
            sendLogToOC("body data is FormData...");

            if (headers instanceof Headers) {
              headers.append("qax_isformdata", "1");
            } else {
              headers["qax_isformdata"] = "1";
            }
            ZTNAJSBridgeUtil.convertFormDataToJson(body, function (json) {
              sendLogToOC("parse formData json:" + JSON.stringify(json));
              requestParamsToOC.data = json;
              window.prompt(
                "FixDropBodyFormData",
                JSON.stringify(requestParamsToOC)
              );
            });
          } else {
            if (iosVersion && iosVersion < 12) {
              sendLogToOC("body data is Others such as String...");
              console.log("other");
              requestParamsToOC.sendBody = body;
              window.prompt(
                "FixDropBody4Fetch",
                JSON.stringify(requestParamsToOC)
              );
            }
          }
        }
      } catch (e) {
        sendLogToOC("Except in hook fetch register:" + e.message);
      }

      return [ori, config];
    },
  };
  function ztna_define_prop() {
    XMLHttpRequest.UNSENT = 0;
    XMLHttpRequest.OPENED = 1;
    XMLHttpRequest.HEADERS_RECEIVED = 2;
    XMLHttpRequest.LOADING = 3;
    XMLHttpRequest.DONE = 4;
  }

  if (window.qaxallhook) {
    sendLogToOC("no repeat hook");
    return;
  } else {
    sendLogToOC("init qax hook");
    window.qaxallhook = 1;
  }

  ztna_initHookAjaxMethod(window);
  sendLogToOC("ztna_xhr_Hook OK,href is: " + window.location.href);
  ztna_HookAjax(ztna_AjaxHookProxy);
  ztna_define_prop();

  ztna_Hook_fetch(window).register(ztna_FetchHookProxy);
  sendLogToOC("ztna_fetch_Hook OK,href is: " + window.location.href);

  ztna_hookFormData();
})(window);
