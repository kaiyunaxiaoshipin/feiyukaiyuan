package com.feiyu.game.bean;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * Created by cxf on 2018/11/3.
 * 游戏庄家信息
 */

public class BankerBean {

    private String mBankerId;
    private String mBankerName;
    private String mBankerAvatar;
    private String mBankerCoin;

    public BankerBean(){

    }

    public BankerBean(String bankerId, String bankerName, String bankerAvatar, String bankerCoin) {
        mBankerId = bankerId;
        mBankerName = bankerName;
        mBankerAvatar = bankerAvatar;
        mBankerCoin = bankerCoin;
    }

    @JSONField(name = "id")
    public String getBankerId() {
        return mBankerId;
    }

    @JSONField(name = "id")
    public void setBankerId(String bankerId) {
        mBankerId = bankerId;
    }

    @JSONField(name = "user_nicename")
    public String getBankerName() {
        return mBankerName;
    }

    @JSONField(name = "user_nicename")
    public void setBankerName(String bankerName) {
        mBankerName = bankerName;
    }

    @JSONField(name = "avatar")
    public String getBankerAvatar() {
        return mBankerAvatar;
    }

    @JSONField(name = "avatar")
    public void setBankerAvatar(String bankerAvatar) {
        mBankerAvatar = bankerAvatar;
    }

    @JSONField(name = "coin")
    public String getBankerCoin() {
        return mBankerCoin;
    }

    @JSONField(name = "coin")
    public void setBankerCoin(String bankerCoin) {
        mBankerCoin = bankerCoin;
    }

}
