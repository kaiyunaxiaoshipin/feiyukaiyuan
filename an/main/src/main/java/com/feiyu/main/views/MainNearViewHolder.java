package com.feiyu.main.views;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.feiyu.common.utils.WordUtil;
import com.feiyu.main.R;

/**
 * Created by cxf on 2018/9/22.
 * 附近
 */

public class MainNearViewHolder extends AbsMainHomeParentViewHolder {

    private MainNearNearViewHolder mNearViewHolder;

    public MainNearViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_main_near;
    }

    @Override
    protected void loadPageData(int position) {
        if (mViewHolders == null) {
            return;
        }
        AbsMainHomeChildViewHolder vh = mViewHolders[position];
        if (vh == null) {
            if (mViewList != null && position < mViewList.size()) {
                FrameLayout parent = mViewList.get(position);
                if (parent == null) {
                    return;
                }
                if (position == 0) {
                    mNearViewHolder = new MainNearNearViewHolder(mContext, parent);
                    vh = mNearViewHolder;
                }
                if (vh == null) {
                    return;
                }
                mViewHolders[position] = vh;
                vh.addToParent();
                vh.subscribeActivityLifeCycle();
            }
        }
        if (vh != null) {
            vh.loadData();
        }
    }

    @Override
    protected int getPageCount() {
        return 1;
    }

    @Override
    protected String[] getTitles() {
        return new String[]{
                WordUtil.getString(R.string.near)
        };
    }

    @Override
    public void loadData() {
        loadPageData(0);
    }
}
