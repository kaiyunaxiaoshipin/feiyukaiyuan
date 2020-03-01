package com.feiyu.common.event;

/**
 * Created by cxf on 2018/9/28.
 */

public class FollowEvent {

    private String mToUid;
    private int mIsAttention;

    public FollowEvent(String toUid, int isAttention) {
        mToUid = toUid;
        mIsAttention = isAttention;
    }

    public String getToUid() {
        return mToUid;
    }

    public void setToUid(String toUid) {
        mToUid = toUid;
    }

    public int getIsAttention() {
        return mIsAttention;
    }

    public void setIsAttention(int isAttention) {
        mIsAttention = isAttention;
    }
}
