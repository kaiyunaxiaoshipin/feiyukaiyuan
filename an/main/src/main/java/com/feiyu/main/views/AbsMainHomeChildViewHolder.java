package com.feiyu.main.views;

import android.content.Context;
import android.view.ViewGroup;

import com.feiyu.main.activity.MainActivity;
import com.feiyu.live.bean.LiveBean;

/**
 * Created by cxf on 2018/9/22.
 * MainActivity中的首页，附近 的子页面
 */

public abstract class AbsMainHomeChildViewHolder extends AbsMainViewHolder {


    public AbsMainHomeChildViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    /**
     * 观看直播
     */
    public void watchLive(LiveBean liveBean, String key, int position) {
        ((MainActivity) mContext).watchLive(liveBean, key, position);
    }
}
