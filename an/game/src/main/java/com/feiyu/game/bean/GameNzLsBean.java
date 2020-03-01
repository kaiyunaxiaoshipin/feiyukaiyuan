package com.feiyu.game.bean;

/**
 * Created by cxf on 2017/10/19.
 * 庄家流水实体类
 */

public class GameNzLsBean {
    private String banker_profit;
    private String banker_card;

    public String getBanker_profit() {
        return banker_profit;
    }

    public void setBanker_profit(String banker_profit) {
        this.banker_profit = banker_profit;
    }

    public String getBanker_card() {
        return banker_card;
    }

    public void setBanker_card(String banker_card) {
        this.banker_card = banker_card;
    }
}
