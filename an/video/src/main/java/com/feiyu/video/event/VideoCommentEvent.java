package com.feiyu.video.event;

/**
 * Created by cxf on 2018/12/17.
 */

public class VideoCommentEvent {
    private String mVideoId;
    private String mCommentNum;

    public VideoCommentEvent(String videoId, String commentNum) {
        mVideoId = videoId;
        mCommentNum = commentNum;
    }

    public String getVideoId() {
        return mVideoId;
    }

    public void setVideoId(String videoId) {
        mVideoId = videoId;
    }

    public String getCommentNum() {
        return mCommentNum;
    }

    public void setCommentNum(String commentNum) {
        mCommentNum = commentNum;
    }
}
