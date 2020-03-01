package com.feiyu.live.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2017/8/22.
 */

public class LiveChatBean {

    public static final int NORMAL = 0;
    public static final int SYSTEM = 1;
    public static final int GIFT = 2;
    public static final int ENTER_ROOM = 3;
    public static final int LIGHT = 4;
    public static final int RED_PACK = 5;

    private String id;
    private String userNiceName;
    private int level;
    private String content;
    private int heart;
    private int type; //0是普通消息  1是系统消息 2是礼物消息
    private String liangName;
    private int vipType;
    private int guardType;
    private boolean anchor;
    private boolean manager;

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

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getHeart() {
        return heart;
    }

    public void setHeart(int heart) {
        this.heart = heart;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    @JSONField(name = "liangname")
    public String getLiangName() {
        return liangName;
    }

    @JSONField(name = "liangname")
    public void setLiangName(String liangName) {
        if(!"0".equals(liangName)){
            this.liangName = liangName;
        }
    }

    public boolean isAnchor() {
        return anchor;
    }

    public void setAnchor(boolean anchor) {
        this.anchor = anchor;
    }

    @JSONField(name = "vip_type")
    public int getVipType() {
        return vipType;
    }

    @JSONField(name = "vip_type")
    public void setVipType(int vipType) {
        this.vipType = vipType;
    }

    public boolean isManager() {
        return manager;
    }

    public void setManager(boolean manager) {
        this.manager = manager;
    }

    @JSONField(name = "guard_type")
    public int getGuardType() {
        return guardType;
    }

    @JSONField(name = "guard_type")
    public void setGuardType(int guardType) {
        this.guardType = guardType;
    }
}
