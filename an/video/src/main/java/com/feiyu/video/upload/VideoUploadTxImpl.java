package com.feiyu.video.upload;

import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.tencent.cos.xml.CosXmlService;
import com.tencent.cos.xml.CosXmlServiceConfig;
import com.tencent.cos.xml.exception.CosXmlClientException;
import com.tencent.cos.xml.exception.CosXmlServiceException;
import com.tencent.cos.xml.listener.CosXmlProgressListener;
import com.tencent.cos.xml.listener.CosXmlResultListener;
import com.tencent.cos.xml.model.CosXmlRequest;
import com.tencent.cos.xml.model.CosXmlResult;
import com.tencent.cos.xml.model.object.PutObjectRequest;
import com.tencent.qcloud.core.auth.QCloudCredentialProvider;
import com.tencent.qcloud.core.auth.SessionQCloudCredentials;
import com.tencent.qcloud.core.auth.StaticCredentialProvider;
import com.feiyu.common.CommonAppContext;
import com.feiyu.common.bean.ConfigBean;
import com.feiyu.common.utils.L;
import com.feiyu.video.http.VideoHttpUtil;

import java.io.File;

/**
 * Created by cxf on 2018/5/21.
 */

public class VideoUploadTxImpl implements VideoUploadStrategy {

    private static final String TAG = "VideoUploadTxImpl";

    private VideoUploadBean mVideoUploadBean;
    private VideoUploadCallback mVideoUploadCallback;
    private OnSuccessCallback mVideoOnSuccessCallback;//视频上传成功回调
    private OnSuccessCallback mImageOnSuccessCallback;//封面图片上传成功回调
    private CosXmlService mCosXmlService;
    private String mAppId;//appId
    private String mRegion;//区域
    private String mBucketName;//桶的名字
    private String mCosVideoPath;//腾讯云存储上面的 视频文件夹
    private String mCosImagePath;//腾讯云存储上面的 图片文件夹

    public VideoUploadTxImpl(ConfigBean configBean) {
        mAppId = configBean.getTxCosAppId();
        mRegion = configBean.getTxCosRegion();
        mBucketName = configBean.getTxCosBucketName();
        mCosVideoPath = configBean.getTxCosVideoPath();
        mCosImagePath = configBean.getTxCosImagePath();
        if (mCosVideoPath == null) {
            mCosVideoPath = "";
        }
        if (!mCosVideoPath.endsWith("/")) {
            mCosVideoPath += "/";
        }
        if (mCosImagePath == null) {
            mCosImagePath = "";
        }
        if (!mCosImagePath.endsWith("/")) {
            mCosImagePath += "/";
        }
        mVideoOnSuccessCallback = new OnSuccessCallback() {
            @Override
            public void onUploadSuccess(String url) {
                if (mVideoUploadBean == null) {
                    return;
                }
                L.e(TAG, "视频上传结果-------->" + url);
                mVideoUploadBean.setResultVideoUrl(url);
                //上传封面图片
                uploadFile(mCosImagePath, mVideoUploadBean.getImageFile(), mImageOnSuccessCallback);
            }
        };
        mImageOnSuccessCallback = new OnSuccessCallback() {
            @Override
            public void onUploadSuccess(String url) {
                if (mVideoUploadBean == null) {
                    return;
                }
                L.e(TAG, "图片上传结果-------->" + url);
                mVideoUploadBean.setResultImageUrl(url);
                if (mVideoUploadCallback != null) {
                    mVideoUploadCallback.onSuccess(mVideoUploadBean);
                }
            }
        };
    }

    @Override
    public void upload(final VideoUploadBean bean, final VideoUploadCallback callback) {
        if (bean == null || callback == null) {
            return;
        }
        mVideoUploadBean = bean;
        mVideoUploadCallback = callback;

        VideoHttpUtil.getTxUploadCredential(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                String result = response.body();
                if (!TextUtils.isEmpty(result)) {
                    JSONObject obj = JSON.parseObject(result);
                    if (obj.getIntValue("code") == 0) {
                        JSONObject data = obj.getJSONObject("data");
                        JSONObject credentials = data.getJSONObject("credentials");
                        startUpload(credentials.getString("tmpSecretId"),
                                credentials.getString("tmpSecretKey"),
                                credentials.getString("sessionToken"),
                                data.getLongValue("expiredTime"));
                    } else {
                        if (mVideoUploadCallback != null) {
                            mVideoUploadCallback.onFailure();
                        }
                    }
                }
            }

            @Override
            public void onError(Response<String> response) {
                super.onError(response);
                if (mVideoUploadCallback != null) {
                    mVideoUploadCallback.onFailure();
                }
            }
        });
    }


    public void startUpload(String secretId, String secretKey, String token, long expiredTime) {
        try {
            SessionQCloudCredentials credentials = new SessionQCloudCredentials(secretId, secretKey, token, expiredTime);
            QCloudCredentialProvider qCloudCredentialProvider = new StaticCredentialProvider(credentials);
            CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
                    .setAppidAndRegion(mAppId, mRegion)
                    .builder();
            mCosXmlService = new CosXmlService(CommonAppContext.sInstance, serviceConfig, qCloudCredentialProvider);
        } catch (Exception e) {
            if (mVideoUploadCallback != null) {
                mVideoUploadCallback.onFailure();
            }
        }
        //上传视频
        uploadFile(mCosVideoPath, mVideoUploadBean.getVideoFile(), mVideoOnSuccessCallback);
    }

    /**
     * 上传文件
     */
    private void uploadFile(String cosPath, File file, final OnSuccessCallback callback) {
        if (mCosXmlService == null) {
            return;
        }
        PutObjectRequest putObjectRequest = new PutObjectRequest(mBucketName, cosPath + file.getName(), file.getAbsolutePath());
        putObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                L.e(TAG, "---上传进度--->" + progress * 100 / max);
            }
        });
        // 使用异步回调上传
        mCosXmlService.putObjectAsync(putObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult cosXmlResult) {
                if (cosXmlResult != null) {
                    String resultUrl = "http://" + cosXmlResult.accessUrl;
                    L.e(TAG, "---上传结果---->  " + resultUrl);
                    if (callback != null) {
                        callback.onUploadSuccess(resultUrl);
                    }
                }
            }

            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException) {

            }
        });
    }

    @Override
    public void cancel() {
        mVideoUploadCallback = null;
        if (mCosXmlService != null) {
            mCosXmlService.release();
        }
        mCosXmlService = null;
    }

    public interface OnSuccessCallback {
        void onUploadSuccess(String url);
    }
}
