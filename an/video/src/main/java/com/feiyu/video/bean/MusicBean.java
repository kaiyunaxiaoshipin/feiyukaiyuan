package com.feiyu.video.bean;

import android.os.Parcel;
import android.os.Parcelable;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2018/6/20.
 */

public class MusicBean implements Parcelable {
    private int id;
    private String title;
    private String author;
    private String imgUrl;
    private String length;
    private String fileUrl;
    private String useNum;
    private String localPath;//本地存储的路径
    private int collect;//是否收藏
    private boolean expand;
    private long mDuration;

    public MusicBean() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    @JSONField(name = "img_url")
    public String getImgUrl() {
        return imgUrl;
    }

    @JSONField(name = "img_url")
    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }

    @JSONField(name = "file_url")
    public String getFileUrl() {
        return fileUrl;
    }

    @JSONField(name = "file_url")
    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    @JSONField(name = "use_nums")
    public String getUseNum() {
        return useNum;
    }

    @JSONField(name = "use_nums")
    public void setUseNum(String useNum) {
        this.useNum = useNum;
    }


    public String getLocalPath() {
        return localPath;
    }

    public void setLocalPath(String localPath) {
        this.localPath = localPath;
    }

    public boolean isExpand() {
        return expand;
    }

    public void setExpand(boolean expand) {
        this.expand = expand;
    }

    @JSONField(name = "iscollect")
    public int getCollect() {
        return collect;
    }

    @JSONField(name = "iscollect")
    public void setCollect(int collect) {
        this.collect = collect;
    }

    public long getDuration() {
        return mDuration;
    }

    public void setDuration(long duration) {
        mDuration = duration;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public MusicBean(Parcel in) {
        this.id = in.readInt();
        this.title = in.readString();
        this.author = in.readString();
        this.imgUrl = in.readString();
        this.length = in.readString();
        this.fileUrl = in.readString();
        this.useNum = in.readString();
        this.localPath = in.readString();
        this.collect = in.readInt();
        this.mDuration=in.readLong();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.title);
        dest.writeString(this.author);
        dest.writeString(this.imgUrl);
        dest.writeString(this.length);
        dest.writeString(this.fileUrl);
        dest.writeString(this.useNum);
        dest.writeString(this.localPath);
        dest.writeInt(this.collect);
        dest.writeLong(this.mDuration);
    }

    public static final Creator<MusicBean> CREATOR = new Creator<MusicBean>() {
        @Override
        public MusicBean[] newArray(int size) {
            return new MusicBean[size];
        }

        @Override
        public MusicBean createFromParcel(Parcel in) {
            return new MusicBean(in);
        }
    };

}
