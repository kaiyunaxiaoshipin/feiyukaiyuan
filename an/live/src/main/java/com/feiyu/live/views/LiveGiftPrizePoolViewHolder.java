package com.feiyu.live.views;

import android.animation.ValueAnimator;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.views.AbsViewHolder;
import com.feiyu.live.R;
import com.feiyu.live.bean.LiveGiftPrizePoolWinBean;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * Created by cxf on 2019/4/30.
 * 直播间奖池子动画
 */

public class LiveGiftPrizePoolViewHolder extends AbsViewHolder {

    private View mMeteor;//流星
    private ImageView mAvatar;
    private TextView mName;
    private TextView mCoin;
    private View mWinView;
    private View mGuang;
    private ValueAnimator mAnimator;
    private ScaleAnimation mScaleAnimation;
    private RotateAnimation mRotateAnimation;
    private int mDp120;
    private ConcurrentLinkedQueue<LiveGiftPrizePoolWinBean> mQueue;
    private boolean mAimating;

    public LiveGiftPrizePoolViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_gift_prize_pool_1;
    }

    @Override
    public void init() {
        mQueue = new ConcurrentLinkedQueue<>();
        mDp120 = DpUtil.dp2px(120);
        mMeteor = findViewById(R.id.meteor);
        mAvatar = (ImageView) findViewById(R.id.avatar);
        mName = (TextView) findViewById(R.id.name);
        mCoin = (TextView) findViewById(R.id.coin);
        mGuang = findViewById(R.id.guang);
        mWinView = findViewById(R.id.win_view);
        mAnimator = ValueAnimator.ofFloat(-mDp120, mParentView.getWidth());
        mAnimator.setDuration(2000);
        mAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                if (mMeteor != null) {
                    float v = (float) animation.getAnimatedValue();
                    mMeteor.setTranslationX(v);
                    mMeteor.setTranslationY(v * 0.7f);
                }
            }
        });

        mScaleAnimation = new ScaleAnimation(0.1f, 1f, 0.1f, 1f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mScaleAnimation.setDuration(500);
        mScaleAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                if (mGuang != null) {
                    mGuang.startAnimation(mRotateAnimation);
                }
                if (mAnimator != null) {
                    mAnimator.start();
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        mRotateAnimation = new RotateAnimation(0, 359, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mRotateAnimation.setDuration(1000);
        mRotateAnimation.setRepeatCount(4);
        mRotateAnimation.setInterpolator(new LinearInterpolator());
        mRotateAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                mAimating = false;
                if (mQueue == null) {
                    return;
                }
                LiveGiftPrizePoolWinBean bean = mQueue.poll();
                if (bean != null) {
                    show(bean);
                } else {
                    if (mWinView != null && mWinView.getVisibility() == View.VISIBLE) {
                        mWinView.setVisibility(View.INVISIBLE);
                    }
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    public void show(LiveGiftPrizePoolWinBean bean) {
        if (mWinView == null) {
            return;
        }
        if (mAimating) {
            if (mQueue != null) {
                mQueue.offer(bean);
            }
            return;
        }
        mAimating = true;
        if (mAvatar != null) {
            ImgLoader.display(mContext, bean.getAvatar(), mAvatar);
        }
        if (mName != null) {
            mName.setText(bean.getName());
        }
        if (mCoin != null) {
            mCoin.setText(bean.getCoin());
        }
        if (mWinView.getVisibility() != View.VISIBLE) {
            mWinView.setVisibility(View.VISIBLE);
        }
        mWinView.startAnimation(mScaleAnimation);
    }


    public void clearAnim() {
        if (mQueue != null) {
            mQueue.clear();
        }
        if (mScaleAnimation != null) {
            mScaleAnimation.cancel();
        }
        if (mRotateAnimation != null) {
            mRotateAnimation.cancel();
        }
        if (mAnimator != null) {
            mAnimator.cancel();
        }
        if (mMeteor != null) {
            mMeteor.setTranslationX(-mDp120);
            mMeteor.setTranslationY(-mDp120);
        }
        if (mGuang != null) {
            mGuang.clearAnimation();
        }
        if (mWinView != null) {
            mWinView.clearAnimation();
            if (mWinView.getVisibility() == View.VISIBLE) {
                mWinView.setVisibility(View.INVISIBLE);
            }
        }
    }

    public void release() {
        if (mQueue != null) {
            mQueue.clear();
        }
        mQueue = null;
        if (mGuang != null) {
            mGuang.clearAnimation();
        }
        if (mWinView != null) {
            mWinView.clearAnimation();
        }
        if (mAnimator != null) {
            mAnimator.cancel();
            mAnimator.removeAllUpdateListeners();
            mAnimator.removeAllListeners();
        }
        if (mScaleAnimation != null) {
            mScaleAnimation.cancel();
            mScaleAnimation.setAnimationListener(null);
        }
        if (mRotateAnimation != null) {
            mRotateAnimation.cancel();
            mRotateAnimation.setAnimationListener(null);
        }
    }
}
