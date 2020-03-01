package com.feiyu.live.dialog;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.Constants;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.StringUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;
import com.feiyu.live.activity.LiveActivity;
import com.feiyu.live.adapter.RedPackAdapter;
import com.feiyu.live.bean.RedPackBean;
import com.feiyu.live.http.LiveHttpConsts;
import com.feiyu.live.http.LiveHttpUtil;
import com.feiyu.live.interfaces.RedPackCountDownListener;

/**
 * Created by cxf on 2018/11/21.
 * 抢红包弹窗
 */

public class LiveRedPackRobDialogFragment extends AbsDialogFragment implements View.OnClickListener, RedPackCountDownListener {

    private View mRobGroup;
    private View mRobGroup1;
    private View mWinGroup;
    private View mResultGroup;
    private View mWaitGroup;
    private ImageView mAvatar;
    private TextView mName;
    private TextView mTitle;
    private TextView mTitle2;
    private View mText;
    private RedPackBean mRedPackBean;
    private String mStream;
    private TextView mMsg;
    private TextView mWinTip;
    private TextView mWinCoin;
    private String mCoinName;
    private TextView mCountDown;
    private RedPackAdapter mRedPackAdapter;
    private ActionListener mActionListener;
    private boolean mNeedDelay;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_live_red_pack_rob;
    }

    @Override
    protected int getDialogStyle() {
        return R.style.dialog2;
    }

    @Override
    protected boolean canCancel() {
        return true;
    }

    @Override
    protected void setWindowAttributes(Window window) {
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = DpUtil.dp2px(300);
        params.height = DpUtil.dp2px(390);
        params.gravity = Gravity.CENTER;
        window.setAttributes(params);
    }

    public void setRedPackBean(RedPackBean bean) {
        mRedPackBean = bean;
    }

    public void setStream(String stream) {
        mStream = stream;
    }

    public void setCoinName(String coinName) {
        mCoinName = coinName;
    }

    public void setRedPackAdapter(RedPackAdapter redPackAdapter) {
        mRedPackAdapter = redPackAdapter;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (mRedPackBean == null || TextUtils.isEmpty(mStream)) {
            return;
        }
        mRobGroup = mRootView.findViewById(R.id.rob_group);
        mRobGroup1 = mRootView.findViewById(R.id.rob_group_1);
        mResultGroup = mRootView.findViewById(R.id.result_group);
        mWinGroup = mRootView.findViewById(R.id.win_group);
        mWaitGroup = mRootView.findViewById(R.id.wait_group);
        mText = mRootView.findViewById(R.id.text);
        mAvatar = mRootView.findViewById(R.id.avatar);
        mName = mRootView.findViewById(R.id.name);
        mTitle = mRootView.findViewById(R.id.title);
        mTitle2 = mRootView.findViewById(R.id.title2);
        mMsg = mRootView.findViewById(R.id.msg);
        mWinTip = mRootView.findViewById(R.id.win_tip);
        mWinCoin = mRootView.findViewById(R.id.win_coin);
        mCountDown = mRootView.findViewById(R.id.count_down);
        mRootView.findViewById(R.id.btn_rob).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_detail).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_detail_2).setOnClickListener(this);
        ImgLoader.displayAvatar(mContext,mRedPackBean.getAvatar(), mAvatar);
        mName.setText(mRedPackBean.getUserNiceName());
        mTitle.setText(mRedPackBean.getTitle());
        mTitle2.setText(mRedPackBean.getTitle());
        if (mRedPackBean.getSendType() == Constants.RED_PACK_SEND_TIME_DELAY && mRedPackBean.getRobTime() != 0) {
            mWaitGroup.setVisibility(View.VISIBLE);
            if (mCountDown != null) {
                mCountDown.setText(StringUtil.getDurationText(mRedPackBean.getRobTime() * 1000));
            }
            if (mRedPackAdapter != null) {
                mRedPackAdapter.setRedPackCountDownListener(this);
            }
        } else {
            startRob();
        }
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.btn_rob) {
            robRedPack();

        } else if (i == R.id.btn_detail || i == R.id.btn_detail_2) {
            forwardRobDetail();

        }
    }

    /**
     * 查看领取详情
     */
    private void forwardRobDetail() {
        LiveRedPackResultDialogFragment fragment = new LiveRedPackResultDialogFragment();
        fragment.setStream(mStream);
        fragment.setRedPackBean(mRedPackBean);
        fragment.setCoinName(mCoinName);
        mNeedDelay = true;
        dismiss();
        fragment.show(((LiveActivity) mContext).getSupportFragmentManager(), "LiveRedPackResultDialogFragment");
    }


    /**
     * 抢红包
     */
    private void robRedPack() {
        if (mRedPackBean == null) {
            return;
        }
        if (mRedPackAdapter != null) {
            mRedPackAdapter.onRobClick(mRedPackBean.getId());
        }
        LiveHttpUtil.robRedPack(mStream, mRedPackBean.getId(), new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0 && info.length > 0) {
                    JSONObject obj = JSON.parseObject(info[0]);
                    int win = obj.getIntValue("win");
                    if (win > 0) {//抢到了红包
                        onWin(String.valueOf(win));
                    } else {//未抢到
                        onNotWin(obj.getString("msg"));
                    }
                    if (mRedPackBean != null) {
                        mRedPackBean.setIsRob(0);
                    }
                }
            }
        });
    }

    private void onWin(String winCoin) {
        if (mActionListener != null) {
            mActionListener.hide();
        }
        if (mText != null) {
            mText.clearAnimation();
        }
        if (mRobGroup != null && mRobGroup.getVisibility() == View.VISIBLE) {
            mRobGroup.setVisibility(View.INVISIBLE);
        }
        if (mWinGroup != null && mWinGroup.getVisibility() != View.VISIBLE) {
            mWinGroup.setVisibility(View.VISIBLE);
        }
        if (mWinCoin != null) {
            mWinCoin.setText(winCoin);
        }
        if (mWinTip != null) {
            mWinTip.setText(String.format(WordUtil.getString(R.string.red_pack_16), mRedPackBean.getUserNiceName(), mCoinName));
        }
    }

    /**
     * 未抢到
     */
    private void onNotWin(String msg) {
        if (mText != null) {
            mText.clearAnimation();
        }
        if (mRobGroup1 != null && mRobGroup1.getVisibility() == View.VISIBLE) {
            mRobGroup1.setVisibility(View.INVISIBLE);
        }
        if (mResultGroup != null && mResultGroup.getVisibility() != View.VISIBLE) {
            mResultGroup.setVisibility(View.VISIBLE);
        }
        if (mMsg != null) {
            mMsg.setText(msg);
        }
    }

    private void startRob() {
        if (mRobGroup1 != null && mRobGroup1.getVisibility() != View.VISIBLE) {
            mRobGroup1.setVisibility(View.VISIBLE);
            ScaleAnimation animation = new ScaleAnimation(1, 2, 1, 2, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
            animation.setDuration(500);
            animation.setRepeatCount(-1);
            animation.setRepeatMode(Animation.REVERSE);
            mText.startAnimation(animation);
        }
    }

    @Override
    public void onDestroy() {
        if (mActionListener != null) {
            mActionListener.show(mNeedDelay);
        }
        mActionListener = null;
        if (mRedPackAdapter != null) {
            mRedPackAdapter.setRedPackCountDownListener(null);
        }
        mRedPackAdapter = null;
        LiveHttpUtil.cancel(LiveHttpConsts.ROB_RED_PACK);
        if (mText != null) {
            mText.clearAnimation();
        }
        super.onDestroy();
    }

    @Override
    public void onCountDown(int lastTime) {
        if (lastTime == 0) {
            if (mWaitGroup != null && mWaitGroup.getVisibility() == View.VISIBLE) {
                mWaitGroup.setVisibility(View.INVISIBLE);
            }
            startRob();
        } else {
            if (mWaitGroup != null && mWaitGroup.getVisibility() != View.VISIBLE) {
                mWaitGroup.setVisibility(View.VISIBLE);
            }
            if (mCountDown != null) {
                mCountDown.setText(StringUtil.getDurationText(lastTime * 1000));
            }
        }
    }

    @Override
    public int getRedPackId() {
        if (mRedPackBean != null) {
            return mRedPackBean.getId();
        }
        return 0;
    }


    public interface ActionListener {

        void show(boolean needDelay);

        void hide();
    }

    public void setActionListener(ActionListener actionListener) {
        mActionListener = actionListener;
    }
}
