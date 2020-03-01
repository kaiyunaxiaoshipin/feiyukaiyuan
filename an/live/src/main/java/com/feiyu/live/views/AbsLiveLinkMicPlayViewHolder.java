package com.feiyu.live.views;

import android.content.Context;
import android.os.Handler;
import android.view.View;
import android.view.ViewGroup;

import com.feiyu.common.views.AbsViewHolder;
import com.feiyu.live.R;

/**
 * Created by cxf on 2019/3/25.
 */

public abstract class AbsLiveLinkMicPlayViewHolder extends AbsViewHolder {

    protected boolean mPaused;//是否切后台了
    protected boolean mStartPlay;//是否开始了播放
    protected boolean mEndPlay;//是否结束了播放
    protected Handler mHandler;
    protected View mBtnClose;
    protected View mLoading;

    public AbsLiveLinkMicPlayViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    public void init() {
        mLoading = findViewById(R.id.loading);
        mBtnClose = findViewById(R.id.btn_close_link_mic);
        mHandler = new Handler();
    }


    public abstract void setOnCloseListener(View.OnClickListener onClickListener);

    public abstract void play(final String url);

    public abstract void release();

    public abstract void resume();

    public abstract void pause();
}
