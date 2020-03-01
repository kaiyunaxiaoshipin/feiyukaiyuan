package com.feiyu.common.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2018/10/9.
 */

public class LevelBean {
    private int level;
    private String thumb;
    private String color;
    private String thumbIcon;

    @JSONField(name = "levelid")
    public int getLevel() {
        return level;
    }

    @JSONField(name = "levelid")
    public void setLevel(int level) {
        this.level = level;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    @JSONField(name = "colour")
    public String getColor() {
        return color;
    }

    @JSONField(name = "colour")
    public void setColor(String color) {
        this.color = color;
    }

    @JSONField(name = "thumb_mark")
    public String getThumbIcon() {
        return thumbIcon;
    }

    @JSONField(name = "thumb_mark")
    public void setThumbIcon(String thumbIcon) {
        this.thumbIcon = thumbIcon;
    }
}
