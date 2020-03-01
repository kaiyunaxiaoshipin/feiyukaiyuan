package com.feiyu.video.utils;

import com.feiyu.video.bean.VideoBean;
import com.feiyu.video.interfaces.VideoScrollDataHelper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cxf on 2018/6/9.
 */

public class VideoStorge {

    private static VideoStorge sInstance;
    private Map<String, List<VideoBean>> mMap;
    private Map<String, VideoScrollDataHelper> mHelperMap;

    private VideoStorge() {
        mMap = new HashMap<>();
        mHelperMap = new HashMap<>();
    }

    public static VideoStorge getInstance() {
        if (sInstance == null) {
            synchronized (VideoStorge.class) {
                if (sInstance == null) {
                    sInstance = new VideoStorge();
                }
            }
        }
        return sInstance;
    }

    public void put(String key, List<VideoBean> list) {
        if (mMap != null) {
            mMap.put(key, list);
        }
    }


    public List<VideoBean> get(String key) {
        if (mMap != null) {
            return mMap.get(key);
        }
        return null;
    }

    public void remove(String key) {
        if (mMap != null) {
            mMap.remove(key);
        }
    }


    public void clear() {
        if (mMap != null) {
            mMap.clear();
        }
        if (mHelperMap != null) {
            mHelperMap.clear();
        }
    }

    public void putDataHelper(String key, VideoScrollDataHelper helper) {
        if (mHelperMap != null) {
            mHelperMap.put(key, helper);
        }
    }


    public VideoScrollDataHelper getDataHelper(String key) {
        if (mHelperMap != null) {
            return mHelperMap.get(key);
        }
        return null;
    }

    public void removeDataHelper(String key) {
        if (mHelperMap != null) {
            mHelperMap.remove(key);
        }
    }
}
