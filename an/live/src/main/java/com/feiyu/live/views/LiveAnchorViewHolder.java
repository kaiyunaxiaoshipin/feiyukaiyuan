package com.feiyu.live.views;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.http.HttpCallback;
import com.feiyu.live.R;
import com.feiyu.live.activity.LiveAnchorActivity;
import com.feiyu.live.http.LiveHttpUtil;

/**
 * Created by cxf on 2018/10/9.
 * 主播直播间逻辑
 */

public class LiveAnchorViewHolder extends AbsLiveViewHolder {

    private ImageView mBtnFunction;
    private View mBtnGameClose;//关闭游戏的按钮
    private View mBtnPk;//主播连麦pk按钮
    private Drawable mDrawable0;
    private Drawable mDrawable1;
    private Drawable mDrawableLinkMic0;//允许连麦
    private Drawable mDrawableLinkMic1;//禁止连麦
    private ImageView mLinkMicIcon;//是否允许连麦的标记
    private TextView mLinkMicTip;//是否允许连麦的提示
    private HttpCallback mChangeLinkMicCallback;
    private boolean mLinkMicEnable;


    public LiveAnchorViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_live_anchor;
    }

    @Override
    public void init() {
        super.init();
        mDrawable0 = ContextCompat.getDrawable(mContext, R.mipmap.icon_live_func_0);
        mDrawable1 = ContextCompat.getDrawable(mContext, R.mipmap.icon_live_func_1);
        mBtnFunction = (ImageView) findViewById(R.id.btn_function);
        mBtnFunction.setImageDrawable(mDrawable0);
        mBtnFunction.setOnClickListener(this);
        mBtnGameClose = findViewById(R.id.btn_close_game);
        mBtnGameClose.setOnClickListener(this);
        findViewById(R.id.btn_close).setOnClickListener(this);
        mBtnPk = findViewById(R.id.btn_pk);
        mBtnPk.setOnClickListener(this);
        mDrawableLinkMic0 = ContextCompat.getDrawable(mContext, R.mipmap.icon_live_link_mic);
        mDrawableLinkMic1 = ContextCompat.getDrawable(mContext, R.mipmap.icon_live_link_mic_1);
        mLinkMicIcon = (ImageView) findViewById(R.id.link_mic_icon);
        mLinkMicTip = (TextView) findViewById(R.id.link_mic_tip);
        findViewById(R.id.btn_link_mic).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        if (!canClick()) {
            return;
        }
        super.onClick(v);
        int i = v.getId();
        if (i == R.id.btn_close) {
            close();

        } else if (i == R.id.btn_function) {
            showFunctionDialog();

        } else if (i == R.id.btn_close_game) {
            closeGame();

        } else if (i == R.id.btn_pk) {
            applyLinkMicPk();

        } else if (i == R.id.btn_link_mic) {
            changeLinkMicEnable();

        }
    }

    /**
     * 设置游戏按钮是否可见
     */
    public void setGameBtnVisible(boolean show) {
        if (mBtnGameClose != null) {
            if (show) {
                if (mBtnGameClose.getVisibility() != View.VISIBLE) {
                    mBtnGameClose.setVisibility(View.VISIBLE);
                }
            } else {
                if (mBtnGameClose.getVisibility() == View.VISIBLE) {
                    mBtnGameClose.setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    /**
     * 关闭游戏
     */
    private void closeGame() {
        ((LiveAnchorActivity) mContext).closeGame();
    }

    /**
     * 关闭直播
     */
    private void close() {
        ((LiveAnchorActivity) mContext).closeLive();
    }

    /**
     * 显示功能弹窗
     */
    private void showFunctionDialog() {
        if (mBtnFunction != null) {
            mBtnFunction.setImageDrawable(mDrawable1);
        }
        ((LiveAnchorActivity) mContext).showFunctionDialog();
    }

    /**
     * 设置功能按钮变暗
     */
    public void setBtnFunctionDark() {
        if (mBtnFunction != null) {
            mBtnFunction.setImageDrawable(mDrawable0);
        }
    }

    /**
     * 设置连麦pk按钮是否可见
     */
    public void setPkBtnVisible(boolean visible) {
        if (mBtnPk != null) {
            if (visible) {
                if (mBtnPk.getVisibility() != View.VISIBLE) {
                    mBtnPk.setVisibility(View.VISIBLE);
                }
            } else {
                if (mBtnPk.getVisibility() == View.VISIBLE) {
                    mBtnPk.setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    /**
     * 发起主播连麦pk
     */
    private void applyLinkMicPk() {
        ((LiveAnchorActivity) mContext).applyLinkMicPk();
    }

    public void setLinkMicEnable(boolean linkMicEnable) {
        mLinkMicEnable = linkMicEnable;
        showLinkMicEnable();
    }

    private void showLinkMicEnable() {
        if (mLinkMicEnable) {
            if (mLinkMicIcon != null) {
                mLinkMicIcon.setImageDrawable(mDrawableLinkMic1);
            }
            if (mLinkMicTip != null) {
                mLinkMicTip.setText(R.string.live_link_mic_5);
            }
        } else {
            if (mLinkMicIcon != null) {
                mLinkMicIcon.setImageDrawable(mDrawableLinkMic0);
            }
            if (mLinkMicTip != null) {
                mLinkMicTip.setText(R.string.live_link_mic_4);
            }
        }
    }


    private void changeLinkMicEnable() {
        if (mChangeLinkMicCallback == null) {
            mChangeLinkMicCallback = new HttpCallback() {
                @Override
                public void onSuccess(int code, String msg, String[] info) {
                    if (code == 0) {
                        showLinkMicEnable();
                    }
                }
            };
        }
        mLinkMicEnable = !mLinkMicEnable;
        LiveHttpUtil.setLinkMicEnable(mLinkMicEnable, mChangeLinkMicCallback);
    }

}
