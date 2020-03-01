package com.feiyu.live.interfaces;

import android.view.ViewGroup;

/**
 * Created by cxf on 2018/12/14.
 */

public interface ILiveLinkMicViewHolder {

    ViewGroup getSmallContainer();

    ViewGroup getRightContainer();

    ViewGroup getPkContainer();

    void changeToLeft();

    void changeToBig();
}
