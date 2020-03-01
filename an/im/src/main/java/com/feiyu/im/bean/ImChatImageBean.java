package com.feiyu.im.bean;

import java.util.List;

/**
 * Created by cxf on 2018/11/10.
 */

public class ImChatImageBean {
    private List<ImMessageBean> list;
    private int position;

    public ImChatImageBean(List<ImMessageBean> list, int position) {
        this.list = list;
        this.position = position;
    }

    public List<ImMessageBean> getList() {
        return list;
    }

    public void setList(List<ImMessageBean> list) {
        this.list = list;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }
}
