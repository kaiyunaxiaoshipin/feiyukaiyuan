package com.feiyu.video.event;

/**
 * Created by cxf on 2018/12/17.
 */

public class VideoLikeEvent {
    private String videoId;
    private int isLike;
    private String likeNum;

    public VideoLikeEvent(String videoId, int isLike, String likeNum) {
        this.videoId = videoId;
        this.isLike = isLike;
        this.likeNum = likeNum;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public int getIsLike() {
        return isLike;
    }

    public void setIsLike(int isLike) {
        this.isLike = isLike;
    }

    public String getLikeNum() {
        return likeNum;
    }

    public void setLikeNum(String likeNum) {
        this.likeNum = likeNum;
    }
}
