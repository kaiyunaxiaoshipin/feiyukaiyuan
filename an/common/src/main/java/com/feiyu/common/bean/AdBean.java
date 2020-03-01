package com.feiyu.common.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2019/4/28.
 */

public class AdBean {
    private String mUrl;
    private String mLink;

    @JSONField(name = "thumb")
    public String getUrl() {
        return mUrl;
    }
    @JSONField(name = "thumb")
    public void setUrl(String url) {
        mUrl = url;
    }
    @JSONField(name = "href")
    public String getLink() {
        return mLink;
    }
    @JSONField(name = "href")
    public void setLink(String link) {
        mLink = link;
    }
}
