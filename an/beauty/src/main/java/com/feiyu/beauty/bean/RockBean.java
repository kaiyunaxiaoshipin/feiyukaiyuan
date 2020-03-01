package com.feiyu.beauty.bean;

import cn.tillusory.sdk.bean.TiRockEnum;

/**
 * Created by cxf on 2018/8/4.
 */

public class RockBean {
    private TiRockEnum mTiRockEnum;
    private boolean mChecked;

    public RockBean(TiRockEnum tiRockEnum) {
        mTiRockEnum = tiRockEnum;
    }

    public boolean isChecked() {
        return mChecked;
    }

    public void setChecked(boolean checked) {
        mChecked = checked;
    }


    public TiRockEnum getTiRockEnum() {
        return mTiRockEnum;
    }
}
