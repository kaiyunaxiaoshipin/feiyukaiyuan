package com.feiyu.live.views;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.view.ViewGroup;

import com.ksyun.media.streamer.capture.CameraCapture;
import com.ksyun.media.streamer.kit.KSYStreamer;
import com.ksyun.media.streamer.logstats.StatsLogReport;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.live.LiveConfig;
import com.feiyu.live.R;
import com.feiyu.live.bean.LiveKsyConfigBean;

/**
 * Created by cxf on 2018/10/26.
 * 连麦推流小窗口  金山sdk
 */

public class LiveLinkMicPushKsyViewHolder extends AbsLiveLinkMicPushViewHolder implements
        KSYStreamer.OnInfoListener, KSYStreamer.OnErrorListener, StatsLogReport.OnLogEventListener {

    private static final String TAG = "LiveLinkMicPushKsyViewHolder";
    private KSYStreamer mStreamer;//金山推流器
    private LiveKsyConfigBean mLiveKsyConfigBean;

    public LiveLinkMicPushKsyViewHolder(Context context, ViewGroup parentView, LiveKsyConfigBean liveKsyConfigBean) {
        super(context, parentView, liveKsyConfigBean);
    }

    @Override
    protected void processArguments(Object... args) {
        mLiveKsyConfigBean = (LiveKsyConfigBean) args[0];
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_link_mic_push_ksy;
    }

    @Override
    public void init() {
        if (mLiveKsyConfigBean == null) {
            mLiveKsyConfigBean = LiveConfig.getDefaultKsyConfig();
        }
        mStreamer = new KSYStreamer(mContext);
        mStreamer.setPreviewFps(mLiveKsyConfigBean.getPreviewFps());//预览采集帧率
        mStreamer.setTargetFps(mLiveKsyConfigBean.getTargetFps());//推流采集帧率
        mStreamer.setVideoKBitrate(mLiveKsyConfigBean.getVideoKBitrate(), mLiveKsyConfigBean.getVideoKBitrateMax(), mLiveKsyConfigBean.getVideoKBitrateMin());//视频码率
        mStreamer.setAudioKBitrate(mLiveKsyConfigBean.getAudioKBitrate());//音频码率
        mStreamer.setCameraCaptureResolution(LiveConfig.PUSH_CAP_RESOLUTION);//采集分辨率
        mStreamer.setPreviewResolution(mLiveKsyConfigBean.getPreviewResolution());//预览分辨率
        mStreamer.setTargetResolution(mLiveKsyConfigBean.getTargetResolution());//推流分辨率
        mStreamer.setIFrameInterval(mLiveKsyConfigBean.getTargetGop());
        mStreamer.setVideoCodecId(LiveConfig.PUSH_ENCODE_TYPE);//H264
        mStreamer.setEncodeMethod(LiveConfig.PUSH_ENCODE_METHOD);//软编
        mStreamer.setVideoEncodeScene(LiveConfig.PUSH_ENCODE_SCENE);//秀场模式
        mStreamer.setVideoEncodeProfile(LiveConfig.PUSH_ENCODE_PROFILE);
        mStreamer.setAudioChannels(2);//双声道推流
        mStreamer.setVoiceVolume(2f);
        mStreamer.setEnableRepeatLastFrame(false);  // 切后台的时候不使用最后一帧
        mStreamer.setEnableAutoRestart(true, 3000); // 自动重启推流
        mStreamer.setCameraFacing(CameraCapture.FACING_FRONT);
        mStreamer.setFrontCameraMirror(true);
        mStreamer.setOnInfoListener(this);
        mStreamer.setOnErrorListener(this);
        mStreamer.setOnLogEventListener(this);
        mStreamer.setDisplayPreview((GLSurfaceView) findViewById(R.id.camera_preview));
    }

    @Override
    public void onInfo(int what, int msg1, int msg2) {
        switch (what) {
            case 1000://初始化完毕
                L.e(TAG, "mStearm--->初始化完毕");
                if (mLivePushListener != null) {
                    mLivePushListener.onPreviewStart();
                }
                break;
            case 0://推流成功
                L.e(TAG, "mStearm--->推流成功");
                mStartPush = true;
                if (mLivePushListener != null) {
                    mLivePushListener.onPushStart();
                }
                break;
        }
    }

    @Override
    public void onError(int what, int msg1, int msg2) {
        switch (what) {
            case -1009://推流url域名解析失败
                L.e(TAG, "mStearm--->推流url域名解析失败");
                break;
            case -1006://网络连接失败，无法建立连接
                L.e(TAG, "mStearm--->网络连接失败，无法建立连接");
                break;
            case -1010://跟RTMP服务器完成握手后,推流失败
                L.e(TAG, "mStearm--->跟RTMP服务器完成握手后,推流失败");
                break;
            case -1007://网络连接断开
                L.e(TAG, "mStearm--->网络连接断开");
                break;
            case -2004://音视频采集pts差值超过5s
                L.e(TAG, "mStearm--->音视频采集pts差值超过5s");
                break;
            case -1004://编码器初始化失败
                L.e(TAG, "mStearm--->编码器初始化失败");
                break;
            case -1003://视频编码失败
                L.e(TAG, "mStearm--->视频编码失败");
                break;
            case -1008://音频初始化失败
                L.e(TAG, "mStearm--->音频初始化失败");
                break;
            case -1011://音频编码失败
                L.e(TAG, "mStearm--->音频编码失败");
                break;
            case -2001: //摄像头未知错误
                L.e(TAG, "mStearm--->摄像头未知错误");
                break;
            case -2002://打开摄像头失败
                L.e(TAG, "mStearm--->打开摄像头失败");
                break;
            case -2003://录音开启失败
                L.e(TAG, "mStearm--->录音开启失败");
                break;
            case -2005://录音开启未知错误
                L.e(TAG, "mStearm--->录音开启未知错误");
                break;
            case -2006://系统Camera服务进程退出
                L.e(TAG, "mStearm--->系统Camera服务进程退出");
                break;
            case -2007://Camera服务异常退出
                L.e(TAG, "mStearm--->Camera服务异常退出");
                break;
        }
        if (mStreamer != null) {
            mStreamer.stopCameraPreview();
            ToastUtil.show(R.string.live_push_failed);
            if (mLivePushListener != null) {
                mLivePushListener.onPushFailed();
            }
        }
    }

    @Override
    public void onLogEvent(StringBuilder singleLogContent) {
        //打印推流信息
        //L.e("mStearm--->" + singleLogContent.toString());
    }

    /**
     * 开始推流
     *
     * @param pushUrl 推流地址
     */
    @Override
    public void startPush(String pushUrl) {
        if (mStreamer != null) {
            mStreamer.startCameraPreview();
            mStreamer.setUrl(pushUrl);
            mStreamer.startStream();
        }
    }

    @Override
    public void release() {
        mLivePushListener = null;
        if (mStreamer != null) {
            mStreamer.stopStream();
            mStreamer.stopCameraPreview();
            mStreamer.release();
            mStreamer.setOnInfoListener(null);
            mStreamer.setOnErrorListener(null);
            mStreamer.setOnLogEventListener(null);
        }
        mStreamer = null;
    }

    @Override
    public void pause() {
        mPaused = true;
        if (mStartPush && mStreamer != null) {
            mStreamer.onPause();
            // 切后台时，将SDK设置为离屏推流模式，继续采集camera数据
            mStreamer.setOffscreenPreview(mStreamer.getPreviewWidth(), mStreamer.getPreviewHeight());
        }
    }

    @Override
    public void resume() {
        if (mPaused && mStartPush && mStreamer != null) {
            mStreamer.onResume();
        }
        mPaused = false;
    }


}
