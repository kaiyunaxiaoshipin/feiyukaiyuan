package com.feiyu.main.views;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.content.Context;
import android.text.Html;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.TextView;

import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.common.views.AbsViewHolder;
import com.feiyu.main.R;
import com.feiyu.main.bean.BonusBean;
import com.feiyu.main.custom.BonusItemView;
import com.feiyu.main.http.MainHttpUtil;

import java.util.List;

/**
 * Created by cxf on 2018/9/30.
 * 每日签到
 */

public class BonusViewHolder extends AbsViewHolder implements View.OnClickListener {

    private View mBg;
    private View mDialog;
    private TextView mDayView;
    private View mResult;
    private View mImg1;
    private View mImg2;
    private View mImgBg;
    private TextView mCoin;
    private View mBtnSign;
    private List<BonusBean> mList;
    private int mDay;//今天是一周的第几天
    private BonusItemView[] mItemViews;

    public BonusViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_bonus;
    }

    @Override
    public void init() {
        mBg = findViewById(R.id.bg);
        mDialog = findViewById(R.id.dialog);
        mDayView = (TextView) findViewById(R.id.day);
        mItemViews = new BonusItemView[6];
        mItemViews[0] = (BonusItemView) findViewById(R.id.btn_day_1);
        mItemViews[1] = (BonusItemView) findViewById(R.id.btn_day_2);
        mItemViews[2] = (BonusItemView) findViewById(R.id.btn_day_3);
        mItemViews[3] = (BonusItemView) findViewById(R.id.btn_day_4);
        mItemViews[4] = (BonusItemView) findViewById(R.id.btn_day_5);
        mItemViews[5] = (BonusItemView) findViewById(R.id.btn_day_6);
        mResult = findViewById(R.id.result);
        mImg1 = findViewById(R.id.img_1);
        mImg2 = findViewById(R.id.img_2);
        mImgBg = findViewById(R.id.img_bg);
        mCoin = (TextView) findViewById(R.id.coin);
        findViewById(R.id.btn_close).setOnClickListener(this);
        mBtnSign = findViewById(R.id.btn_sign);
        mBtnSign.setOnClickListener(this);
    }

    public void setData(List<BonusBean> list, int day, String continueDay) {
        mList = list;
        mDay = day;
        String s = WordUtil.getString(R.string.bonus_sign_1) + "<font color='#ffdd00'>" + continueDay + "</font>" + WordUtil.getString(R.string.bonus_day);
        mDayView.setText(Html.fromHtml(s));
        for (int i = 0, length = mItemViews.length; i < length; i++) {
            if (i <= mDay - 1) {
                mItemViews[i].setChecked(true);
            } else {
                break;
            }
        }
    }

    public void show() {
        ViewParent parent = mContentView.getParent();
        if (parent != null) {
            ((ViewGroup) parent).removeView(mContentView);
        }
        if (mParentView != null) {
            mParentView.addView(mContentView);
        }
        mBg.animate().alpha(1f).setDuration(300).start();
    }

    private void dismiss() {
        if (mImgBg != null) {
            mImgBg.clearAnimation();
        }
        ViewParent parent = mContentView.getParent();
        if (parent != null && parent == mParentView) {
            mParentView.removeView(mContentView);
        }
    }

    @Override
    public void onClick(View v) {
        if (!canClick()) {
            return;
        }
        int i = v.getId();
        if (i == R.id.btn_close) {
            dismiss();
        } else if (i == R.id.btn_sign) {
            getBonus();
        }
    }

    /**
     * 获取签到奖励
     */
    private void getBonus() {
        mBtnSign.setClickable(false);
        MainHttpUtil.getBonus(new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0) {
                    playSuccessAnim();
                } else {
                    ToastUtil.show(msg);
                }
            }
        });
    }

    /**
     * 播放签到成功动画
     */
    private void playSuccessAnim() {
        mDialog.setVisibility(View.INVISIBLE);
        mResult.setVisibility(View.VISIBLE);
        RotateAnimation rotateAnimation = new RotateAnimation(0, 359f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotateAnimation.setInterpolator(new LinearInterpolator());
        rotateAnimation.setDuration(1500);
        rotateAnimation.setRepeatCount(-1);
        rotateAnimation.setRepeatMode(Animation.RESTART);
        mImgBg.startAnimation(rotateAnimation);
        ValueAnimator valueAnimator = ValueAnimator.ofFloat(0.5f, 1.15f, 1f);
        valueAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                float v = (float) animation.getAnimatedValue();
                mImg1.setScaleX(v);
                mImg1.setScaleY(v);
                mImg2.setScaleX(v);
                mImg2.setScaleY(v);
            }
        });
        valueAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                showCoin();
            }
        });
        valueAnimator.setDuration(600);
        valueAnimator.setInterpolator(new AccelerateDecelerateInterpolator());
        valueAnimator.start();
    }

    private void showCoin() {
        mCoin.setVisibility(View.VISIBLE);
        mCoin.setText("+" + mList.get(mDay - 1).getCoin());
        ValueAnimator valueAnimator = ValueAnimator.ofFloat(0.5f, 1.5f, 1f);
        valueAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                float v = (float) animation.getAnimatedValue();
                mCoin.setScaleX(v);
                mCoin.setScaleY(v);
            }
        });
        valueAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                if (mCoin != null) {
                    mCoin.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            if (mImgBg != null) {
                                mImgBg.clearAnimation();
                            }
                            if (mBg != null && mImg1 != null && mImg2 != null && mCoin != null) {
                                playHideAnim();
                            }
                        }
                    }, 500);
                }
            }
        });
        valueAnimator.setDuration(500);
        valueAnimator.setInterpolator(new AccelerateDecelerateInterpolator());
        valueAnimator.start();
    }

    private void playHideAnim() {
        ValueAnimator valueAnimator = ValueAnimator.ofFloat(1f, 0.2f);
        valueAnimator.setDuration(500);
        valueAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                float v = (float) animation.getAnimatedValue();
                mBg.setAlpha(1 - animation.getAnimatedFraction());
                mImg1.setScaleX(v);
                mImg1.setScaleY(v);
                mImg2.setScaleX(v);
                mImg2.setScaleY(v);
                mCoin.setScaleX(v);
                mCoin.setScaleY(v);
            }
        });
        valueAnimator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                dismiss();
            }
        });
        valueAnimator.start();
    }
}
