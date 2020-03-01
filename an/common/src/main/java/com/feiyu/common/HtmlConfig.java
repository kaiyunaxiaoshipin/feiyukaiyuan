package com.feiyu.common;

/**
 * Created by cxf on 2018/10/15.
 */

public class HtmlConfig {

    //登录即代表同意服务和隐私条款
    public static final String LOGIN_PRIVCAY = CommonAppConfig.HOST + "/index.php?g=portal&m=page&a=index&id=4";
    //直播间贡献榜
    public static final String LIVE_LIST = CommonAppConfig.HOST + "/index.php?g=Appapi&m=contribute&a=index&uid=";
    //个人主页分享链接
    public static final String SHARE_HOME_PAGE = CommonAppConfig.HOST + "/index.php?g=Appapi&m=home&a=index&touid=";
    //提现记录
    public static final String CASH_RECORD = CommonAppConfig.HOST + "/index.php?g=Appapi&m=cash&a=index";
    //支付宝回调地址
    public static final String ALI_PAY_NOTIFY_URL = CommonAppConfig.HOST + "/Appapi/Pay/notify_ali";
    //视频分享地址
    public static final String SHARE_VIDEO = CommonAppConfig.HOST +"/index.php?g=appapi&m=video&a=index&videoid=";
    //直播间幸运礼物说明
    public static final String LUCK_GIFT_TIP = CommonAppConfig.HOST +"/index.php?g=portal&m=page&a=index&id=26";

}
