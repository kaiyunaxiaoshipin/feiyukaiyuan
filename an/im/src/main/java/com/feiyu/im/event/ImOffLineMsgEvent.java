package com.feiyu.im.event;

import com.feiyu.im.bean.ImUserBean;

/**
 * Created by cxf on 2018/7/20.
 * IM收到离线消息 事件
 */

public class ImOffLineMsgEvent {
    private ImUserBean mBean;

    public ImOffLineMsgEvent(ImUserBean bean) {
        mBean = bean;
    }

}