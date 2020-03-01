package com.feiyu.im.http;

import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.http.HttpClient;

/**
 * Created by cxf on 2019/2/26.
 */

public class ImHttpUtil {

    /**
     * 取消网络请求
     */
    public static void cancel(String tag) {
        HttpClient.getInstance().cancel(tag);
    }

    /**
     * 私信聊天页面用于获取用户信息
     */
    public static void getImUserInfo(String uids, HttpCallback callback) {
        HttpClient.getInstance().get("User.GetUidsInfo", ImHttpConsts.GET_IM_USER_INFO)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("uids", uids)
                .execute(callback);
    }

    /**
     * 获取系统消息列表
     */
    public static void getSystemMessageList(int p, HttpCallback callback) {
        HttpClient.getInstance().get("Message.GetList", ImHttpConsts.GET_SYSTEM_MESSAGE_LIST)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("p", p)
                .execute(callback);
    }

    /**
     * 判断自己有没有被对方拉黑，聊天的时候用到
     */
    public static void checkBlack(String touid, HttpCallback callback) {
        HttpClient.getInstance().get("User.checkBlack", ImHttpConsts.CHECK_BLACK)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("touid", touid)
                .execute(callback);
    }


}
