package com.feiyu.live.bean;

import com.ksyun.media.streamer.filter.imgtex.ImgTexFilter;
import com.ksyun.media.streamer.framework.ImgTexFormat;
import com.ksyun.media.streamer.framework.ImgTexFrame;
import com.ksyun.media.streamer.framework.SinkPin;
import com.ksyun.media.streamer.framework.SrcPin;
import com.ksyun.media.streamer.util.gles.GLRender;

import cn.tillusory.sdk.TiSDKManager;
import cn.tillusory.sdk.bean.TiRotation;

/**
 * Created by cxf on 2018/8/4.
 */

public class TiFilter extends ImgTexFilter {

    private SrcPin<ImgTexFrame> mSrcPin;
    private GLRender mGLRender;
    private int mOutTexture = ImgTexFrame.NO_TEXTURE;
    private SinkPin<ImgTexFrame> mTexSinkPin;
    private final Object BUF_LOCK = new Object();
    private TiSDKManager mTiSDKManager;

    public TiFilter(TiSDKManager tiSDKManager, GLRender glRender) {
        super(glRender);
        mTiSDKManager = tiSDKManager;
        mGLRender = glRender;

        mTexSinkPin = new TiFancyTexSinPin();

        mSrcPin = new SrcPin<>();
    }

    @Override
    public SinkPin<ImgTexFrame> getSinkPin() {
        return mTexSinkPin;
    }

    @Override
    public SrcPin<ImgTexFrame> getSrcPin() {
        return mSrcPin;
    }

    @Override
    public int getSinkPinNum() {
        return 2;
    }

    private class TiFancyTexSinPin extends SinkPin<ImgTexFrame> {
        @Override
        public void onFormatChanged(Object format) {
            ImgTexFormat fmt = (ImgTexFormat) format;

            mSrcPin.onFormatChanged(fmt);
        }

        @Override
        public void onFrameAvailable(ImgTexFrame frame) {
            if (mSrcPin.isConnected()) {

                synchronized (BUF_LOCK) {
                    mOutTexture = mTiSDKManager.renderTexture2D(frame.textureId, frame.format.width, frame.format.height,
                            TiRotation.CLOCKWISE_ROTATION_180, true);
                }
            }

            ImgTexFrame outFrame = new ImgTexFrame(frame.format, mOutTexture, null, frame.pts);
            mSrcPin.onFrameAvailable(outFrame);
        }

        @Override
        public void onDisconnect(boolean recursive) {
            if (recursive) {
                mSrcPin.disconnect(true);
                if (mOutTexture != ImgTexFrame.NO_TEXTURE) {
                    mGLRender.getFboManager().unlock(mOutTexture);
                    mOutTexture = ImgTexFrame.NO_TEXTURE;
                }
                mTiSDKManager.destroy();
            }
        }
    }
}
