package com.feiyu.im.receiver;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.CommonAppContext;
import com.feiyu.common.Constants;
import com.feiyu.common.R;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.RouteUtil;
import com.feiyu.common.utils.SpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.im.event.SystemMsgEvent;
import com.feiyu.im.utils.ImPushUtil;

import org.greenrobot.eventbus.EventBus;

import java.util.List;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.data.JPushLocalNotification;


/**
 * Created by cxf on 2018/10/30.
 */

public class JPushReceiver extends BroadcastReceiver {

    private static final String TAG = "极光推送";
    private Context mContext;

    @Override
    public void onReceive(Context context, Intent intent) {
        mContext = context;
        switch (intent.getAction()) {
            case "cn.jpush.android.intent.REGISTRATION":
                L.e(TAG, "-------->用户注册");
                break;
            case "cn.jpush.android.intent.MESSAGE_RECEIVED":
                L.e(TAG, "-------->用户接收SDK消息");
                break;
            case "cn.jpush.android.intent.NOTIFICATION_RECEIVED":
                L.e(TAG, "-------->用户收到通知栏信息");
                onReceiveNotification(context, intent);
                break;
            case "cn.jpush.android.intent.NOTIFICATION_OPENED":
                L.e(TAG, "-------->用户打开通知栏信息");
                onClickNotification(context, intent);
                break;
        }
    }

    /**
     * 收到通知
     */
    private void onReceiveNotification(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        if (bundle == null) {
            return;
        }
        String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
        L.e(TAG, "------extras----->" + extras);
        if (TextUtils.isEmpty(extras)) {
            return;
        }
        JSONObject obj = JSON.parseObject(extras);
        if (obj == null || obj.containsKey("local")) {//收到的是本地通知
            return;
        }
        if (obj.getIntValue("type") == Constants.JPUSH_TYPE_MESSAGE) {//系统消息通知
            SpUtil.getInstance().setBooleanValue(SpUtil.HAS_SYSTEM_MSG, true);
            EventBus.getDefault().post(new SystemMsgEvent());
        }
        if (!CommonAppConfig.getInstance().isFrontGround()) {
            L.e(TAG, "---------->处于后台，显示通知");
            String content = obj.getString("title");
            if (TextUtils.isEmpty(content)) {
                return;
            }
            showNotification(context, obj, content);
        } else {
            L.e(TAG, "---------->处于前台，不显示通知");
        }
    }

    /**
     * 显示通知
     */
    private void showNotification(Context context, JSONObject extrasJson, String content) {
        JPushLocalNotification localNotification = new JPushLocalNotification();
        localNotification.setTitle(WordUtil.getString(R.string.app_name));
        extrasJson.put("local", 1);
        localNotification.setExtras(extrasJson.toJSONString());
        localNotification.setContent(content);
        JPushInterface.addLocalNotification(context, localNotification);
    }

    /**
     * 点击通知栏
     */
    private void onClickNotification(Context context, Intent intent) {
        L.e(TAG, "------->通知被点击");
        JPushInterface.clearAllNotifications(context);
        if (intent == null) {
            return;
        }
        Bundle bundle = intent.getExtras();
        if (bundle == null) {
            return;
        }
        String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
        L.e(TAG, "------extras----->" + extras);
        if (TextUtils.isEmpty(extras)) {
            return;
        }
        JSONObject obj = JSON.parseObject(extras);
        if (obj == null) {
            return;
        }
        if (!CommonAppConfig.getInstance().isLaunched()) {
            ImPushUtil.getInstance().setClickNotification(true);
            ImPushUtil.getInstance().setNotificationType(obj.getIntValue("type"));
            RouteUtil.forwardLauncher(mContext);
        } else {
            ActivityManager mAm = (ActivityManager) CommonAppContext.sInstance.getSystemService(Context.ACTIVITY_SERVICE);
            //获得当前运行的task
            List<ActivityManager.RunningTaskInfo> taskList = mAm.getRunningTasks(100);
            for (ActivityManager.RunningTaskInfo rti : taskList) {
                //找到当前应用的task，并启动task的栈顶activity，达到程序切换到前台
                if (rti.topActivity.getPackageName().equals(CommonAppContext.sInstance.getPackageName())) {
                    mAm.moveTaskToFront(rti.id, 0);
                    break;
                }
            }
        }

    }


}
