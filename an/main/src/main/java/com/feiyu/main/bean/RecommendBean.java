package com.feiyu.main.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2018/11/2.
 */

public class RecommendBean {

    private String id;
    private String userNiceName;
    private String avatar;
    private String avatarThumb;
    private String fans;
    private String attention;
    private boolean checked;

    public RecommendBean() {
        this.checked = true;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @JSONField(name = "user_nicename")
    public String getUserNiceName() {
        return userNiceName;
    }

    @JSONField(name = "user_nicename")
    public void setUserNiceName(String userNiceName) {
        this.userNiceName = userNiceName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @JSONField(name = "avatar_thumb")
    public String getAvatarThumb() {
        return avatarThumb;
    }

    @JSONField(name = "avatar_thumb")
    public void setAvatarThumb(String avatarThumb) {
        this.avatarThumb = avatarThumb;
    }

    public String getFans() {
        return fans;
    }

    public void setFans(String fans) {
        this.fans = fans;
    }

    @JSONField(name = "isattention")
    public String getAttention() {
        return attention;
    }

    @JSONField(name = "isattention")
    public void setAttention(String attention) {
        this.attention = attention;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public void toggleChecked() {
        this.checked = !this.checked;
    }
}
