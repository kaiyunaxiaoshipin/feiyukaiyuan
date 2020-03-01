package com.feiyu.live.views;

import android.content.Context;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.ksyun.media.player.IMediaPlayer;
import com.ksyun.media.player.KSYMediaPlayer;
import com.ksyun.media.player.KSYTextureView;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;

import java.io.IOException;

/**
 * Created by cxf on 2018/10/10.
 * 直播间播放器 金山播放器
 */

public class LivePlayKsyViewHolder extends LiveRoomPlayViewHolder implements
        IMediaPlayer.OnPreparedListener, IMediaPlayer.OnErrorListener, IMediaPlayer.OnInfoListener {

    private static final String TAG = "LivePlayViewHolder";
    private ViewGroup mRoot;
    private ViewGroup mSmallContainer;
    private ViewGroup mLeftContainer;
    private ViewGroup mRightContainer;
    private ViewGroup mPkContainer;
    private KSYTextureView mVideoView;
    private View mLoading;
    private ImageView mCover;
    private boolean mPaused;//是否切后台了
    private boolean mStarted;//是否开始了播放
    private boolean mEnd;//是否结束了播放

    private boolean mPausedPlay;//是否被动暂停了播放


    public LivePlayKsyViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_live_play_ksy;
    }

    @Override
    public void init() {
        mRoot = (ViewGroup) findViewById(R.id.root);
        mSmallContainer = (ViewGroup) findViewById(R.id.small_container);
        mLeftContainer = (ViewGroup) findViewById(R.id.left_container);
        mRightContainer = (ViewGroup) findViewById(R.id.right_container);
        mPkContainer = (ViewGroup) findViewById(R.id.pk_container);
        mVideoView = (KSYTextureView) findViewById(R.id.video_view);
        mLoading = findViewById(R.id.loading);
        mCover = (ImageView) findViewById(R.id.cover);
        mVideoView.setOnPreparedListener(this);
        mVideoView.setOnErrorListener(this);
        mVideoView.setOnInfoListener(this);
        mVideoView.setTimeout(5000, 5000);
        mVideoView.setVolume(2f, 2f);
        mVideoView.setLooping(true);//循环播放
        mVideoView.setDecodeMode(KSYMediaPlayer.KSYDecodeMode.KSY_DECODE_MODE_AUTO);
        mVideoView.setVideoScalingMode(KSYMediaPlayer.VIDEO_SCALING_MODE_SCALE_TO_FIT_WITH_CROPPING);
    }

    @Override
    public void hideCover() {
        if (mCover != null) {
            mCover.animate().alpha(0).setDuration(500).start();
        }
    }

    @Override
    public void setCover(String coverUrl) {
        if (mCover != null) {
            ImgLoader.displayBlur(mContext,coverUrl, mCover);
        }
    }

    /**
     * 暂停播放
     */
    @Override
    public void pausePlay() {
        if (!mPausedPlay) {
            mPausedPlay = true;
            if (!mPaused) {
                if (mVideoView != null) {
                    mVideoView.runInBackground(false);
                }
            }
            if (mCover != null) {
                mCover.setAlpha(1f);
                if (mCover.getVisibility() != View.VISIBLE) {
                    mCover.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    /**
     * 暂停播放后恢复
     */
    @Override
    public void resumePlay() {
        if (mPausedPlay) {
            mPausedPlay = false;
            if (!mPaused) {
                if (mVideoView != null) {
                    mVideoView.runInForeground();
                    mVideoView.start();
                }
            }
            hideCover();
        }
    }

    /**
     * 开始播放
     *
     * @param url 流地址
     */
    @Override
    public void play(String url) {
        if (TextUtils.isEmpty(url) || mVideoView == null) {
            return;
        }
        mEnd = false;
        if (mStarted) {
            mVideoView.reload(url, true, KSYMediaPlayer.KSYReloadMode.KSY_RELOAD_MODE_FAST);
        }
        try {
            mVideoView.setDataSource(url);
            mVideoView.prepareAsync();
        } catch (IOException e) {
            e.printStackTrace();
        }
        L.e(TAG, "play----url--->" + url);
    }

    @Override
    public void release() {
        mEnd = true;
        mVideoView.stop();
        mVideoView.reset();
        mVideoView.release();
        mVideoView.setOnPreparedListener(null);
        mVideoView.setOnErrorListener(null);
        mVideoView.setOnInfoListener(null);
        mStarted = false;
        L.e(TAG, "release------->");
    }

    @Override
    public void stopPlay() {
        if (mCover != null) {
            mCover.setAlpha(1f);
            if (mCover.getVisibility() != View.VISIBLE) {
                mCover.setVisibility(View.VISIBLE);
            }
        }
        stopPlay2();
    }

    @Override
    public void stopPlay2() {
        if (mVideoView != null) {
            mVideoView.stop();
        }
    }

    /**
     * 播放开始
     */
    @Override
    public void onPrepared(IMediaPlayer mp) {
        if (mEnd) {
            release();
            return;
        }
        mStarted = true;
        int width = mp.getVideoWidth();
        int height = mp.getVideoHeight();
        L.e(TAG, "流---width----->" + width);
        L.e(TAG, "流---height----->" + height);
        if (width >= height) {
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) mVideoView.getLayoutParams();
            float rate = ((float) width) / height;
            params.height = (int) (mVideoView.getWidth() / rate);
            params.addRule(RelativeLayout.CENTER_IN_PARENT);
            mVideoView.requestLayout();
        }
        hideCover();
    }

    @Override
    public boolean onError(IMediaPlayer iMediaPlayer, int what, int extra) {
//        switch (what) {
//            //网络较差播放过程中触发设置超时时间，报错退出
//            case -10011://播放http+mp4点播流，弱网环境
//            case -10002://播放http(mp4/flv/hls)点播流，无效wifi环境,连接无效wifi，播放rtmp直播流
//            case -10004://播放rtmp直播流，弱网环境
//            case -1004://播播http+flv点播流，播放过程中断网
//            case -10007:
//            case -10008://播放无效的http地址,超时设置足够长
//            case 1:
//                break;
//        }
        ToastUtil.show(WordUtil.getString(R.string.live_play_error));
        return false;
    }

    @Override
    public boolean onInfo(IMediaPlayer iMediaPlayer, int info, int extra) {
        switch (info) {
            case KSYMediaPlayer.MEDIA_INFO_BUFFERING_START://缓冲开始
                if (mLoading != null && mLoading.getVisibility() != View.VISIBLE) {
                    mLoading.setVisibility(View.VISIBLE);
                }
                break;
            case KSYMediaPlayer.MEDIA_INFO_BUFFERING_END://缓冲结束
                if (mLoading != null && mLoading.getVisibility() == View.VISIBLE) {
                    mLoading.setVisibility(View.INVISIBLE);
                }
                break;
        }
        return false;
    }


    @Override
    public ViewGroup getSmallContainer() {
        return mSmallContainer;
    }


    @Override
    public ViewGroup getRightContainer() {
        return mRightContainer;
    }

    @Override
    public ViewGroup getPkContainer() {
        return mPkContainer;
    }

    @Override
    public void changeToLeft() {
        if (mVideoView != null) {
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(mVideoView.getWidth() / 2, DpUtil.dp2px(250));
            params.setMargins(0, DpUtil.dp2px(130), 0, 0);
            mVideoView.setLayoutParams(params);
        }
        if (mLoading != null && mLeftContainer != null) {
            ViewParent viewParent = mLoading.getParent();
            if (viewParent != null) {
                ((ViewGroup) viewParent).removeView(mLoading);
            }
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(DpUtil.dp2px(24), DpUtil.dp2px(24));
            params.gravity = Gravity.CENTER;
            mLoading.setLayoutParams(params);
            mLeftContainer.addView(mLoading);
        }
    }

    @Override
    public void changeToBig() {
        if (mVideoView != null) {
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            mVideoView.setLayoutParams(params);
        }
        if (mLoading != null && mRoot != null) {
            ViewParent viewParent = mLoading.getParent();
            if (viewParent != null) {
                ((ViewGroup) viewParent).removeView(mLoading);
            }
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(DpUtil.dp2px(24), DpUtil.dp2px(24));
            params.addRule(RelativeLayout.CENTER_IN_PARENT);
            mLoading.setLayoutParams(params);
            mRoot.addView(mLoading);
        }
    }

    @Override
    public void onResume() {
        if (!mPausedPlay && mPaused && mVideoView != null) {
            mVideoView.runInForeground();
            mVideoView.start();
        }
        mPaused = false;
    }

    @Override
    public void onPause() {
        if (!mPausedPlay && mVideoView != null) {
            mVideoView.runInBackground(false);
        }
        mPaused = true;
    }

    @Override
    public void onDestroy() {
        release();
    }

}
