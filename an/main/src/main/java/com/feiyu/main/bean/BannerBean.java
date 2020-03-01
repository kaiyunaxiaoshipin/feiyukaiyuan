package com.feiyu.main.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2019/3/30.
 */

public class BannerBean {
    private String mImageUrl;
    private String mLink;

    @JSONField(name = "slide_pic")
    public String getImageUrl() {
        return mImageUrl;
    }

    @JSONField(name = "slide_pic")
    public void setImageUrl(String imageUrl) {
        mImageUrl = imageUrl;
    }

    @JSONField(name = "slide_url")
    public String getLink() {
        return mLink;
    }

    @JSONField(name = "slide_url")
    public void setLink(String link) {
        mLink = link;
    }
}
