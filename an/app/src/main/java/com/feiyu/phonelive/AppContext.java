package com.feiyu.phonelive;

import android.text.TextUtils;

import com.alibaba.android.arouter.launcher.ARouter;
import com.mob.MobSDK;
//import com.squareup.leakcanary.LeakCanary;
import com.tencent.bugly.crashreport.CrashReport;
import com.tencent.rtmp.TXLiveBase;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.CommonAppContext;
import com.feiyu.common.utils.L;
import com.feiyu.im.utils.ImMessageUtil;
import com.feiyu.im.utils.ImPushUtil;

import cn.tillusory.sdk.TiSDK;


/**
 * Created by cxf on 2017/8/3.
 */

public class AppContext extends CommonAppContext {

    public static AppContext sInstance;
    private boolean mBeautyInited;

    @Override
    public void onCreate() {
        super.onCreate();
        sInstance = this;
        //腾讯云鉴权url
        String ugcLicenceUrl = "http://license.vod2.myqcloud.com/license/v1/b13ac98104ff105115ca4c93c2953521/TXUgcSDK.licence";
        //腾讯云鉴权key
        String ugcKey = "65b13299241b1cc80acaa96511bb9594";
        TXLiveBase.getInstance().setLicence(this, ugcLicenceUrl, ugcKey);
        L.setDeBug(BuildConfig.DEBUG);
        //初始化腾讯bugly
        CrashReport.initCrashReport(this);
        CrashReport.setAppVersion(this, CommonAppConfig.getInstance().getVersion());
        //初始化ShareSdk
        MobSDK.init(this);
        //初始化极光推送
        ImPushUtil.getInstance().init(this);
        //初始化极光IM
        ImMessageUtil.getInstance().init();

        //初始化 ARouter
        if (BuildConfig.DEBUG) {
            ARouter.openLog();
            ARouter.openDebug();
        }
        ARouter.init(this);

//        if (!LeakCanary.isInAnalyzerProcess(this)) {
//            LeakCanary.install(this);
//        }
    }

    /**
     * 初始化萌颜
     */
    public void initBeautySdk(String beautyKey) {
        if(!TextUtils.isEmpty(beautyKey)){
            if (!mBeautyInited) {
                mBeautyInited = true;
                TiSDK.init(beautyKey, this);
                CommonAppConfig.getInstance().setTiBeautyEnable(true);
                L.e("萌颜初始化------->");
            }
        }else{
            CommonAppConfig.getInstance().setTiBeautyEnable(false);
        }

    }

}
