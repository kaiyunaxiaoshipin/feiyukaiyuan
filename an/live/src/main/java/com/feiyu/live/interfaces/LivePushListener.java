package com.feiyu.live.interfaces;

/**
 * Created by cxf on 2018/10/7.
 */

public interface LivePushListener {
    void onPreviewStart();

    void onPushStart();

    void onPushFailed();
}
