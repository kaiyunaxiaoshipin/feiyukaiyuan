package com.feiyu.video.upload;

/**
 * Created by cxf on 2018/5/21.
 */

public interface VideoUploadCallback {
    void onSuccess(VideoUploadBean bean);

    void onFailure();
}
