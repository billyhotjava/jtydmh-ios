package com.secure.sslvpn;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.VpnService;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.JsonArray;
import com.secure.comm.utils.SPJSONUtil;
import com.secure.comm.view.SPPopupMsgBox;
import com.secure.comm.view.SPPopupWaiting;
import com.secure.sportal.sdk.LibSecIDSDKLite;
import com.secure.sportal.sdk.SPVPNClient;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opencv.samples.facedetect.FdActivity;

import java.util.Properties;

import static android.app.Activity.RESULT_OK;

/**
 * 创建日期：2019/8/30 on 10:46
 * 描述:sslvpn插件
 * 作者:guifeng.li
 */
public class SSLVPNPlugin extends CordovaPlugin implements SPVPNClient.OnVPNLoginCallback{

    public static final String ERROR_MESSAGE = "ERROR";
    public CallbackContext callbackContext;
    private Intent intent;
    private SPPopupWaiting mWaitingDlg;
    private VPNTunnelStateReceiver tunnelStateReceiver;
    private SessionStatusReceiver sessionStatusReceiver;


    @Override
        public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        this.callbackContext = callbackContext;
        mWaitingDlg = SPPopupWaiting.create(cordova.getActivity(), "", null, null, "取消", null);
        tunnelStateReceiver = new VPNTunnelStateReceiver();
        sessionStatusReceiver = new SessionStatusReceiver();
        SPVPNClient.registVPNTunnelStateReceiver(cordova.getActivity(), tunnelStateReceiver);
        SPVPNClient.registSessionStateReceiver(cordova.getActivity(), sessionStatusReceiver);
        if (action.equals("loginVPN")) {
            this.loginVPN(args.getString(0), args.getString(1), args.getString(2), args.getString(3),args.getString(4));
        } else if(action.equals("logoutVPN")){
            this.logoutVPN(args, callbackContext);
         } else {
            return false;
        }
        return true;
    }

    public void loginVPN(final String mVPNHost, final String mVPNPort,final String mVPNAuth,final String mVPNUserName, final String mVPNPassWord){
        Properties param = new Properties();
        // SSLVPN 服务器地址，支持主机名和IP地址
        param.setProperty(SPVPNClient.PARAM_VPN_HOST, mVPNHost);

        // SSLVPN 服务器端口号
        param.setProperty(SPVPNClient.PARAM_VPN_PORT, mVPNPort);

        // SSLVPN 认证服务器名称（如果不填，则SDK自动使用第一个作为默认值）
        param.setProperty(SPVPNClient.PARAM_AUTH_SERVER, mVPNAuth);
        // SSLVPN 登录用户名
        param.setProperty(SPVPNClient.PARAM_AUTH_USERNAME, mVPNUserName);

        // SSLVPN 登录密码
        param.setProperty(SPVPNClient.PARAM_AUTH_PASSWORD, mVPNPassWord);

        SPVPNClient.login(cordova.getActivity(), param, this);
        mWaitingDlg.setMessage("第一步认证中");

        mWaitingDlg.dialog().show();

    }

    public void logoutVPN(final JSONArray args, CallbackContext callbackContext){
        SPVPNClient.logout();
//        SPPopupMsgBox.popup(cordova.getActivity(), "提示", "SSLVPN下线了");
      //  Toast.makeText(cordova.getActivity(),"SSLVPN下线了",Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onVPNLoginMessage(int msgid, String msg) {
        mWaitingDlg.close(0);
        switch (msgid){
            case SPVPNClient.MSGID_LOGIN_SUCC:
//                establishVPNTunnel();
                accomplishVPNLogin();
                callbackContext.success();
                break;
            case SPVPNClient.MSGID_LOGIN_FAIL:
            default:
                SPPopupMsgBox.popup(cordova.getActivity(), "提示", "登录VPN失败: " + msg);
                callbackContext.error("登陆失败");
               // Toast.makeText(cordova.getActivity(),"登陆失败",Toast.LENGTH_SHORT).show();
                break;
        }

    }

    // 按需启动全局VPN隧道
    private void establishVPNTunnel() {
        if (SPVPNClient.needsVPNTunnel()) {
            Intent intent = VpnService.prepare(cordova.getActivity());
            if (intent != null) {
                cordova.getActivity().startActivityForResult(intent, SPVPNClient.REQUEST_CODE_VPN_TUNNEL);
            } else {
                onActivityResult(SPVPNClient.REQUEST_CODE_VPN_TUNNEL, RESULT_OK, intent);
            }
        } else {
            accomplishVPNLogin();
        }
    }

    private void accomplishVPNLogin() {
        //enableButtons(true);
        // SSLVPN 登录完成
        SPPopupMsgBox.popup(cordova.getActivity(), "提示", "SSLVPN登录成功");
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == SPVPNClient.REQUEST_CODE_VPN_TUNNEL) {
            if (resultCode == Activity.RESULT_OK) {
                SPVPNClient.startVPNTunnel(cordova.getActivity(), true, 0);
                accomplishVPNLogin();
            }
        }
//        else if (requestCode == LibSecIDSDKLite.REQUEST_CODE_GEN_TOKEN) {
//            if (resultCode == Activity.RESULT_OK) {
//                int errcode = data.getIntExtra(LibSecIDSDKLite.KEY_SECID_ERRCODE, 0);
//                if (0 == errcode) {
//                    // 获取360ID口令成功，用口令进行第二步验证
//                    String token = data.getStringExtra(LibSecIDSDKLite.KEY_TOTP_TOKEN);
//                    String username = data.getStringExtra(LibSecIDSDKLite.KEY_SECID_USERNAME);
//                    loginSecondaryWith360IDToken(TextUtils.isEmpty(username) ? "test1" : username, token);
//                } else {
//                    SPPopupMsgBox.popup(this, "提示",
//                            "获取360ID安全口令失败: " + data.getStringExtra(LibSecIDSDKLite.KEY_SECID_ERRMSG));
//                }
//            } else {
//                SPPopupMsgBox.popup(this, "提示", "获取360ID安全口令失败");
//            }
//        }
        else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public void onResume(boolean multitasking) {
        SPVPNClient.registVPNTunnelStateReceiver(cordova.getActivity(), tunnelStateReceiver);
        SPVPNClient.registSessionStateReceiver(cordova.getActivity(), sessionStatusReceiver);
        super.onResume(multitasking);
    }

    @Override
    public void onDestroy() {
        SPVPNClient.unregistBroadcastReceiver(cordova.getActivity(), tunnelStateReceiver);
        SPVPNClient.unregistBroadcastReceiver(cordova.getActivity(), sessionStatusReceiver);
        SPVPNClient.logout();
        super.onDestroy();
    }

    private class VPNTunnelStateReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            StringBuilder msg = new StringBuilder("VPN隧道状态变化 ");
            int state = intent.getIntExtra(SPVPNClient.EXTRA_KEY_NC_TUNNEL_STATE, 0);
            if (state == SPVPNClient.NC_TUNNEL_STATE_CONNECTING) {
                msg.append("连接中");
            } else if (state == SPVPNClient.NC_TUNNEL_STATE_CONNECTED) {
                msg.append("已连接");
            } else if (state == SPVPNClient.NC_TUNNEL_STATE_ERROR) {
                msg.append("出错了");
            } else {
                msg.append("已停止");
            }
           // Toast.makeText(context, msg.toString(), Toast.LENGTH_LONG).show();
            Log.d("demo", msg.toString());
        }
    }

    private class SessionStatusReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String topic = intent.getStringExtra("topic");
            String content = intent.getStringExtra("content");
            Log.d("demo", "SSLVPN-Session-State topic: " + topic);
            Log.d("demo", "SSLVPN-Session-State content: " + content);
            if ("session_status".equals(topic)) {
                JSONObject json = SPJSONUtil.parseObject(content);
                if ("offline".equals(json.optString("session_state"))) {
//                    SPPopupMsgBox.popup(cordova.getActivity(), "提示", "SSLVPN下线了");
                    SPVPNClient.logout();
                   // enableButtons(false);

                }
            }
        }
    }

    //预加载so文件
    static {
        System.loadLibrary("secure_portal");
    }
}
