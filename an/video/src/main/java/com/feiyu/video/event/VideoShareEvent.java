package com.feiyu.video.event;

/**
 * Created by cxf on 2018/12/17.
 */

public class VideoShareEvent {
    private String videoId;
    private String shareNum;

    public VideoShareEvent(String videoId, String shareNum) {
        this.videoId = videoId;
        this.shareNum = shareNum;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getShareNum() {
        return shareNum;
    }

    public void setShareNum(String shareNum) {
        this.shareNum = shareNum;
    }
}
