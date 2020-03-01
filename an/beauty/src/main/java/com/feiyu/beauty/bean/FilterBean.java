package com.feiyu.beauty.bean;

import cn.tillusory.sdk.bean.TiFilterEnum;

/**
 * Created by cxf on 2018/8/4.
 */

public class FilterBean {

    private int mImgSrc;
    private int mFilterSrc;
    private TiFilterEnum mTiFilterEnum;
    private boolean mChecked;
    private int mKsyFilterType;//金山自带滤镜类型

    public FilterBean() {
    }

    public FilterBean(TiFilterEnum tiFilterEnum) {
        mTiFilterEnum = tiFilterEnum;
    }


    public FilterBean(int imgSrc, int filterSrc, TiFilterEnum tiFilterEnum) {
        mImgSrc = imgSrc;
        mFilterSrc = filterSrc;
        mTiFilterEnum = tiFilterEnum;
    }


    public FilterBean(int imgSrc, int filterSrc, TiFilterEnum tiFilterEnum, int ksyFilterType) {
        this(imgSrc, filterSrc, tiFilterEnum);
        mKsyFilterType = ksyFilterType;
    }

    public FilterBean(int imgSrc, int filterSrc, TiFilterEnum tiFilterEnum, int ksyFilterType, boolean checked) {
        this(imgSrc, filterSrc, tiFilterEnum, ksyFilterType);
        mChecked = checked;
    }

    public int getImgSrc() {
        return mImgSrc;
    }

    public void setImgSrc(int imgSrc) {
        this.mImgSrc = imgSrc;
    }

    public int getFilterSrc() {
        return mFilterSrc;
    }

    public void setFilterSrc(int filterSrc) {
        mFilterSrc = filterSrc;
    }

    public TiFilterEnum getTiFilterEnum() {
        return mTiFilterEnum;
    }

    public boolean isChecked() {
        return mChecked;
    }

    public void setChecked(boolean checked) {
        mChecked = checked;
    }

    public int getKsyFilterType() {
        return mKsyFilterType;
    }

    public void setKsyFilterType(int ksyFilterType) {
        mKsyFilterType = ksyFilterType;
    }
}
