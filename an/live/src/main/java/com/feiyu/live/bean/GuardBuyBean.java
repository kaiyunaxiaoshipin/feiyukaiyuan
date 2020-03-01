package com.feiyu.live.bean;

import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;

/**
 * Created by cxf on 2018/11/6.
 * 守护商品类型
 */

public class GuardBuyBean {

    private int id;
    private String name;
    private int type;
    private int coin;
    private int[] privilege;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getCoin() {
        return coin;
    }

    public void setCoin(int coin) {
        this.coin = coin;
    }

    public int[] getPrivilege() {
        return privilege;
    }

    public void setPrivilege(int[] privilege) {
        this.privilege = privilege;
    }

    public String getShopName() {
        switch (this.id) {
            case 1:
                return WordUtil.getString(R.string.guard_name_1);
            case 2:
                return WordUtil.getString(R.string.guard_name_2);
            case 3:
                return WordUtil.getString(R.string.guard_name_3);
        }
        return "";
    }
}
