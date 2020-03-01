package com.feiyu.video.upload;

import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.convert.StringConvert;
import com.lzy.okgo.model.Progress;
import com.lzy.okgo.request.PostRequest;
import com.lzy.okserver.OkUpload;
import com.lzy.okserver.upload.UploadListener;
import com.lzy.okserver.upload.UploadTask;
import com.feiyu.common.http.Data;
import com.feiyu.common.http.JsonBean;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.RouteUtil;

/**
 * Created by cxf on 2018/12/21.
 * 上传视频，不使用云存储，使用自建存储，比如ftp服务器等
 */

public class VideoUploadFtpImpl implements VideoUploadStrategy {

    private static final String TAG = "VideoUploadFtpImpl";
    private UploadTask<String> mTask;


    @Override
    public void upload(final VideoUploadBean videoUploadBean, final VideoUploadCallback callback) {
        if (videoUploadBean == null || callback == null) {
            return;
        }
        PostRequest<String> postRequest = OkGo.<String>post("http://www.mytoday.net/api/public/?service=Video.uploadvideo")
                .params("uid", "13640")
                .params("token", "0e6371c5a642e8b48748a4d994303473")
                .params("file", videoUploadBean.getVideoFile())
                .params("file1", videoUploadBean.getImageFile())
                .converter(new StringConvert());
        mTask = OkUpload.request(TAG, postRequest)
                .save()
                .register(new UploadListener<String>(TAG) {
                    @Override
                    public void onStart(Progress progress) {
                        L.e(TAG, "onStart------progress----->" + progress.fraction * 100);
                    }

                    @Override
                    public void onProgress(Progress progress) {
                        L.e(TAG, "onProgress------progress----->" + progress.fraction * 100);
                    }

                    @Override
                    public void onError(Progress progress) {
                        L.e(TAG, "onProgress------progress----->" + progress.fraction * 100);
                    }

                    @Override
                    public void onFinish(String s, Progress progress) {
                        L.e(TAG, "onFinish------progress----->" + progress.fraction * 100);
                        L.e(TAG, "onFinish------s----->" + s);
                        if (!TextUtils.isEmpty(s)) {
                            try {
                                JsonBean bean = JSON.parseObject(s, JsonBean.class);
                                if (bean != null) {
                                    if (200 == bean.getRet()) {
                                        Data data = bean.getData();
                                        if (data != null) {
                                            if (700 == data.getCode()) {
                                                //token过期，重新登录
                                                RouteUtil.forwardLoginInvalid(data.getMsg());
                                                if (callback != null) {
                                                    callback.onFailure();
                                                }
                                            } else {
                                                String[] info = data.getInfo();
                                                if (data.getCode() == 0 && info.length > 0) {
                                                    JSONObject obj = JSON.parseObject(info[0]);
                                                    if (videoUploadBean != null) {
                                                        videoUploadBean.setResultVideoUrl(obj.getString("video"));
                                                        videoUploadBean.setResultImageUrl(obj.getString("img"));
                                                        if (callback != null) {
                                                            callback.onSuccess(videoUploadBean);
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            L.e("服务器返回值异常--->ret: " + bean.getRet() + " msg: " + bean.getMsg());
                                            if (callback != null) {
                                                callback.onFailure();
                                            }
                                        }
                                    } else {
                                        L.e("服务器返回值异常--->ret: " + bean.getRet() + " msg: " + bean.getMsg());
                                        if (callback != null) {
                                            callback.onFailure();
                                        }
                                    }

                                } else {
                                    L.e("服务器返回值异常--->bean = null");
                                    if (callback != null) {
                                        callback.onFailure();
                                    }
                                }
                            } catch (Exception e) {
                                if (callback != null) {
                                    callback.onFailure();
                                }
                            }
                        }
                    }

                    @Override
                    public void onRemove(Progress progress) {
                        L.e(TAG, "onRemove------progress----->" + progress);
                        if (callback != null) {
                            callback.onFailure();
                        }
                    }
                });
        mTask.start();

    }

    @Override
    public void cancel() {
        if (mTask != null) {
            mTask.remove();
        }
    }
}
