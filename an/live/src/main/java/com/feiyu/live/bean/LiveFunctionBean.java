package com.feiyu.live.bean;

/**
 * Created by cxf on 2017/8/19.
 * 主播直播间 功能列表 实体类
 */

public class LiveFunctionBean {

    private int mID;
    private int mIcon;
    private int mName;

    public LiveFunctionBean(int ID, int icon, int name) {
        mID = ID;
        mIcon = icon;
        mName = name;
    }

    public int getID() {
        return mID;
    }

    public void setID(int ID) {
        mID = ID;
    }

    public int getIcon() {
        return mIcon;
    }

    public void setIcon(int icon) {
        mIcon = icon;
    }

    public int getName() {
        return mName;
    }

    public void setName(int name) {
        mName = name;
    }
}
