package com.feiyu.main.utils;

import android.util.SparseIntArray;

import com.feiyu.common.Constants;
import com.feiyu.main.R;

/**
 * Created by cxf on 2018/10/11.
 */

public class MainIconUtil {
    private static SparseIntArray sLiveTypeMap;//直播间类型图标
    private static SparseIntArray sCashTypeMap;//提现图片

    static {
        sLiveTypeMap = new SparseIntArray();
        sLiveTypeMap.put(Constants.LIVE_TYPE_NORMAL, R.mipmap.icon_main_live_type_0);
        sLiveTypeMap.put(Constants.LIVE_TYPE_PWD, R.mipmap.icon_main_live_type_1);
        sLiveTypeMap.put(Constants.LIVE_TYPE_PAY, R.mipmap.icon_main_live_type_2);
        sLiveTypeMap.put(Constants.LIVE_TYPE_TIME, R.mipmap.icon_main_live_type_3);


        sCashTypeMap = new SparseIntArray();
        sCashTypeMap.put(Constants.CASH_ACCOUNT_ALI, R.mipmap.icon_cash_ali);
        sCashTypeMap.put(Constants.CASH_ACCOUNT_WX, R.mipmap.icon_cash_wx);
        sCashTypeMap.put(Constants.CASH_ACCOUNT_BANK, R.mipmap.icon_cash_bank);

    }

    public static int getLiveTypeIcon(int key) {
        return sLiveTypeMap.get(key);
    }


    public static int getCashTypeIcon(int key) {
        return sCashTypeMap.get(key);
    }

}
