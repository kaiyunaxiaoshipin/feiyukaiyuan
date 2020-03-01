package com.feiyu.beauty.interfaces;

import com.feiyu.beauty.bean.FilterBean;

/**
 * Created by cxf on 2018/10/8.
 * 基础美颜回调
 */

public interface DefaultBeautyEffectListener extends BeautyEffectListener {

    void onFilterChanged(FilterBean filterBean);

    void onMeiBaiChanged(int progress);

    void onMoPiChanged(int progress);

    void onHongRunChanged(int progress);

}
