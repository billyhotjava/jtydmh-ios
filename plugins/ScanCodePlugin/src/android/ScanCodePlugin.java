package com.eccl.jtmh;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import com.eccl.jtmh.zxing.activity.CaptureActivity;
import org.json.JSONArray;
import org.json.JSONException;

import io.cordova.hellocordova.R;
import pub.devrel.easypermissions.EasyPermissions;
import pub.devrel.easypermissions.PermissionRequest;

/**
 * 创建日期：2021/6/23 on 15:29
 * 描述: 扫码插件
 * 作者:guifeng.li
 */
public class ScanCodePlugin extends CordovaPlugin {

    public CallbackContext callbackContext;
    private Intent intent;
    public static final String ERROR_MESSAGE = "ERROR";
    private final int SCAN_CODE = 10000;//扫码

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;

        if (!hasCamera()) {
            callbackContext.error("No camera detected");
            return false;
        }
        if (action.equals("scan")) {
            intent = new Intent(cordova.getActivity().getApplicationContext(), CaptureActivity.class);
            this.scan(args.getInt(0));
        } else {
            return false;
        }

        return true;
    }

    /**
     * 检查是否有摄像头
     *
     * @return
     */
    private boolean hasCamera() {
        Context context = cordova.getActivity().getApplicationContext();
        PackageManager manager = context.getPackageManager();
        return manager.hasSystemFeature(PackageManager.FEATURE_CAMERA);
    }

    /**
     * 扫码
     */
    public void scan(final int type) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                && cordova.getActivity().getApplicationContext().checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            EasyPermissions.requestPermissions(
                    new PermissionRequest.Builder(cordova.getActivity(), 1000, Manifest.permission.CAMERA)
                            .setRationale(R.string.tip_request_camera)
                            .setPositiveButtonText(R.string.ask_ok)
                            .setNegativeButtonText(R.string.ask_cancel)
                            .build());
        } else {
            this.cordova.startActivityForResult(this, intent, SCAN_CODE);
        }

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (resultCode == Activity.RESULT_OK) {

            if (data == null) {

            } else {
                Bundle bundle = data.getExtras();
                String scanResult = bundle.getString("result");
                //设置数据
                callbackContext.success(scanResult);
            }

        }  else {
            Bundle extras = intent.getExtras();
            String strError = extras.getString(ERROR_MESSAGE);
            if (strError != null) {
                callbackContext.error(strError);
            } else {
                callbackContext.error("Unknown error");
            }
        }
    }

}
