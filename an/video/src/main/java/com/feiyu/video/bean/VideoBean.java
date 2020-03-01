package com.feiyu.video.bean;

import android.os.Parcel;
import android.os.Parcelable;

import com.alibaba.fastjson.annotation.JSONField;
import com.feiyu.common.bean.UserBean;

/**
 * Created by cxf on 2017/10/25.
 */

public class VideoBean implements Parcelable {
    private String id;
    private String uid;
    private String title;
    private String thumb;
    private String thumbs;
    private String href;
    private String likeNum;
    private String viewNum;
    private String commentNum;
    private String stepNum;
    private String shareNum;
    private String addtime;
    private String lat;
    private String lng;
    private String city;
    private UserBean userBean;
    private String datetime;
    private String distance;
    private int step;//是否踩过
    private int like;//是否赞过
    private int attent;//是否关注过作者
    private int status;
    private int musicId;
    private MusicBean musicInfo;

    public VideoBean() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    @JSONField(name = "thumb_s")
    public String getThumbs() {
        return thumbs;
    }

    @JSONField(name = "thumb_s")
    public void setThumbs(String thumbs) {
        this.thumbs = thumbs;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    @JSONField(name = "likes")
    public String getLikeNum() {
        return likeNum;
    }

    @JSONField(name = "likes")
    public void setLikeNum(String likeNum) {
        this.likeNum = likeNum;
    }

    @JSONField(name = "views")
    public String getViewNum() {
        return viewNum;
    }

    @JSONField(name = "views")
    public void setViewNum(String viewNum) {
        this.viewNum = viewNum;
    }

    @JSONField(name = "comments")
    public String getCommentNum() {
        return commentNum;
    }

    @JSONField(name = "comments")
    public void setCommentNum(String commentNum) {
        this.commentNum = commentNum;
    }

    @JSONField(name = "steps")
    public String getStepNum() {
        return stepNum;
    }

    @JSONField(name = "steps")
    public void setStepNum(String stepNum) {
        this.stepNum = stepNum;
    }

    @JSONField(name = "shares")
    public String getShareNum() {
        return shareNum;
    }

    @JSONField(name = "shares")
    public void setShareNum(String shareNum) {
        this.shareNum = shareNum;
    }

    public String getAddtime() {
        return addtime;
    }

    public void setAddtime(String addtime) {
        this.addtime = addtime;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLng() {
        return lng;
    }

    public void setLng(String lng) {
        this.lng = lng;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }


    @JSONField(name = "userinfo")
    public UserBean getUserBean() {
        return userBean;
    }

    @JSONField(name = "userinfo")
    public void setUserBean(UserBean userBean) {
        this.userBean = userBean;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }

    @JSONField(name = "isstep")
    public int getStep() {
        return step;
    }

    @JSONField(name = "isstep")
    public void setStep(int step) {
        this.step = step;
    }

    @JSONField(name = "islike")
    public int getLike() {
        return like;
    }

    @JSONField(name = "islike")
    public void setLike(int like) {
        this.like = like;
    }

    @JSONField(name = "isattent")
    public int getAttent() {
        return attent;
    }

    @JSONField(name = "isattent")
    public void setAttent(int attent) {
        this.attent = attent;
    }

    public String getDistance() {
        return distance;
    }

    public void setDistance(String distance) {
        this.distance = distance;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @JSONField(name = "music_id")
    public int getMusicId() {
        return musicId;
    }

    @JSONField(name = "music_id")
    public void setMusicId(int musicId) {
        this.musicId = musicId;
    }

    @JSONField(name = "musicinfo")
    public MusicBean getMusicInfo() {
        return musicInfo;
    }

    @JSONField(name = "musicinfo")
    public void setMusicInfo(MusicBean musicInfo) {
        this.musicInfo = musicInfo;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.id);
        dest.writeString(this.uid);
        dest.writeString(this.title);
        dest.writeString(this.thumb);
        dest.writeString(this.thumbs);
        dest.writeString(this.href);
        dest.writeString(this.likeNum);
        dest.writeString(this.viewNum);
        dest.writeString(this.commentNum);
        dest.writeString(this.stepNum);
        dest.writeString(this.shareNum);
        dest.writeString(this.addtime);
        dest.writeString(this.lat);
        dest.writeString(this.lng);
        dest.writeString(this.city);
        dest.writeString(this.datetime);
        dest.writeInt(this.like);
        dest.writeInt(this.attent);
        dest.writeString(this.distance);
        dest.writeInt(this.step);
        dest.writeParcelable(this.userBean, flags);
        dest.writeInt(this.status);
        dest.writeInt(this.musicId);
        dest.writeParcelable(this.musicInfo, flags);
    }


    public VideoBean(Parcel in) {
        this.id = in.readString();
        this.uid = in.readString();
        this.title = in.readString();
        this.thumb = in.readString();
        this.thumbs = in.readString();
        this.href = in.readString();
        this.likeNum = in.readString();
        this.viewNum = in.readString();
        this.commentNum = in.readString();
        this.stepNum = in.readString();
        this.shareNum = in.readString();
        this.addtime = in.readString();
        this.lat = in.readString();
        this.lng = in.readString();
        this.city = in.readString();
        this.datetime = in.readString();
        this.like = in.readInt();
        this.attent = in.readInt();
        this.distance = in.readString();
        this.step = in.readInt();
        this.userBean = in.readParcelable(UserBean.class.getClassLoader());
        this.status = in.readInt();
        this.musicId = in.readInt();
        this.musicInfo = in.readParcelable(MusicBean.class.getClassLoader());
    }


    public static final Creator<VideoBean> CREATOR = new Creator<VideoBean>() {
        @Override
        public VideoBean[] newArray(int size) {
            return new VideoBean[size];
        }

        @Override
        public VideoBean createFromParcel(Parcel in) {
            return new VideoBean(in);
        }
    };

    @Override
    public String toString() {
        return "VideoBean{" +
                "title='" + title + '\'' +
                ",href='" + href + '\'' +
                ",id='" + id + '\'' +
                ",uid='" + uid + '\'' +
                ",userNiceName='" + userBean.getUserNiceName() + '\'' +
                ",thumb='" + thumb + '\'' +
                '}';
    }


    public String getTag() {
        return "VideoBean" + this.getId() + this.hashCode();
    }

}
