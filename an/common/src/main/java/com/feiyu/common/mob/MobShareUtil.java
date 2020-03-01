package com.feiyu.common.mob;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

import com.tencent.connect.share.QQShare;
import com.tencent.tauth.Tencent;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.CommonAppContext;
import com.feiyu.common.Constants;
import com.feiyu.common.R;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;

/**
 * Created by cxf on 2017/8/29.
 * Mob 分享
 */

public class MobShareUtil {

    private PlatformActionListener mPlatformActionListener;
    private MobCallback mMobCallback;


    public MobShareUtil() {
        mPlatformActionListener = new PlatformActionListener() {

            @Override
            public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
                if (mMobCallback != null) {
                    mMobCallback.onSuccess(null);
                    mMobCallback.onFinish();
                    mMobCallback = null;
                    ToastUtil.show(R.string.share_success);
                }
            }

            @Override
            public void onError(Platform platform, int i, Throwable throwable) {
                if (mMobCallback != null) {
                    mMobCallback.onError();
                    mMobCallback.onFinish();
                    mMobCallback = null;
                    ToastUtil.show(R.string.share_failed);
                }
            }

            @Override
            public void onCancel(Platform platform, int i) {
                if (mMobCallback != null) {
                    mMobCallback.onCancel();
                    mMobCallback.onFinish();
                    mMobCallback = null;
                    ToastUtil.show(R.string.share_cancel);
                }
            }
        };
    }

    public void execute(String platType, ShareData data, MobCallback callback) {
        if (TextUtils.isEmpty(platType) || data == null) {
            return;
        }
        String platName = MobConst.MAP.get(platType);
        if (TextUtils.isEmpty(platName)) {
            return;
        }
        mMobCallback = callback;
        OnekeyShare oks = new OnekeyShare();
        oks.disableSSOWhenAuthorize();//设置一个总开关，用于在分享前若需要授权，则禁用sso功能
        oks.setPlatform(platName);
        oks.setSilent(true);//是否直接分享
        oks.setSite(WordUtil.getString(R.string.app_name));//site是分享此内容的网站名称，仅在QQ空间使用，否则可以不提供
        oks.setSiteUrl(CommonAppConfig.HOST);//siteUrl是分享此内容的网站地址，仅在QQ空间使用，否则可以不提供
        oks.setTitle(data.getTitle());
        oks.setText(data.getDes());
        oks.setImageUrl(data.getImgUrl());
        String webUrl = data.getWebUrl();
        oks.setUrl(webUrl);
        oks.setTitleUrl(webUrl);
        oks.setCallback(mPlatformActionListener);
        oks.show(CommonAppContext.sInstance);
        L.e("分享-----url--->" + webUrl);
    }

    /**
     * 分享图片
     */
    public void shareImage(Context context, String platType, String imagePath, MobCallback callback) {
        if (TextUtils.isEmpty(platType)) {
            return;
        }
        String platName = MobConst.MAP.get(platType);
        if (TextUtils.isEmpty(platName)) {
            return;
        }
        if (platName.equals(QQ.NAME)) {
            if (!CommonAppConfig.isAppExist(Constants.PACKAGE_NAME_QQ)) {
                ToastUtil.show(R.string.coin_qq_not_install);
                return;
            }
            Intent intent = new Intent(Intent.ACTION_SEND);
            intent.setType("image/*");
            intent.putExtra(Intent.EXTRA_STREAM, imagePath);
            intent.setPackage("com.tencent.mobileqq");
            intent.setComponent(new ComponentName("com.tencent.mobileqq", "com.tencent.mobileqq.activity.JumpActivity"));
            context.startActivity(intent);
        } else if (platName.equals(QZone.NAME)) {
            if (!CommonAppConfig.isAppExist(Constants.PACKAGE_NAME_QQ)) {
                ToastUtil.show(R.string.coin_qq_not_install);
                return;
            }
            Tencent tencent = Tencent.createInstance("101804394", context); //腾讯开放平台appid
            Bundle bundle = new Bundle();
            bundle.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_IMAGE);  //注意，要向qq空间分享纯图片，只能传这三个参数，不能传其他的
            bundle.putString(QQShare.SHARE_TO_QQ_IMAGE_LOCAL_URL, imagePath);  //localImgUrl必须是本地手机图片地址
            bundle.putInt(QQShare.SHARE_TO_QQ_EXT_INT, QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN);
            tencent.shareToQQ(((Activity) context), bundle, null);
        } else {
            mMobCallback = callback;
            Platform platform = ShareSDK.getPlatform(platName);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setImagePath(imagePath);
            shareParams.setShareType(Platform.SHARE_IMAGE);
            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        }
    }

    public void release() {
        mMobCallback = null;
    }

}
