package com.feiyu.game.bean;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.alibaba.fastjson.JSONObject;
import com.feiyu.game.interfaces.GameActionListener;

/**
 * Created by cxf on 2018/11/3.
 */

public class GameParam {

    private Context mContext;
    private ViewGroup mParentView;
    private ViewGroup mInnerContainer;
    private View mTopView;
    private GameActionListener mGameActionListener;
    private String mLiveUid;
    private String mStream;
    private boolean mAnchor;
    private String mCoinName;
    private JSONObject mObj;

    public Context getContext() {
        return mContext;
    }

    public void setContext(Context context) {
        mContext = context;
    }

    public ViewGroup getParentView() {
        return mParentView;
    }

    public void setParentView(ViewGroup parentView) {
        mParentView = parentView;
    }

    public ViewGroup getInnerContainer() {
        return mInnerContainer;
    }

    public void setInnerContainer(ViewGroup innerContainer) {
        mInnerContainer = innerContainer;
    }

    public View getTopView() {
        return mTopView;
    }

    public void setTopView(View topView) {
        mTopView = topView;
    }

    public GameActionListener getGameActionListener() {
        return mGameActionListener;
    }

    public void setGameActionListener(GameActionListener gameActionListener) {
        mGameActionListener = gameActionListener;
    }

    public String getLiveUid() {
        return mLiveUid;
    }

    public void setLiveUid(String liveUid) {
        mLiveUid = liveUid;
    }

    public String getStream() {
        return mStream;
    }

    public void setStream(String stream) {
        mStream = stream;
    }

    public boolean isAnchor() {
        return mAnchor;
    }

    public void setAnchor(boolean anchor) {
        mAnchor = anchor;
    }

    public JSONObject getObj() {
        return mObj;
    }

    public void setObj(JSONObject obj) {
        mObj = obj;
    }

    public String getCoinName() {
        return mCoinName;
    }

    public void setCoinName(String coinName) {
        mCoinName = coinName;
    }
}
