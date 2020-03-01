package com.feiyu.video.event;

/**
 * Created by cxf on 2018/12/15.
 */

public class VideoScrollPageEvent {

    private String mKey;
    private int mPage;

    public VideoScrollPageEvent(String key, int page) {
        mKey = key;
        mPage = page;
    }

    public String getKey() {
        return mKey;
    }

    public int getPage() {
        return mPage;
    }

}
