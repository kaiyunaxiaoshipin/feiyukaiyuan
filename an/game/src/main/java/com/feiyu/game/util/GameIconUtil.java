package com.feiyu.game.util;

import android.util.SparseIntArray;

import com.feiyu.game.R;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by cxf on 2018/10/31.
 */

public class GameIconUtil {
    private static SparseIntArray sGameIconMap;//游戏图标
    private static SparseIntArray sGameNameMap;//游戏名称
    private static Map<String, Integer> sPokerMap;//扑克牌
    private static Map<String, Integer> sJinHuaResult;//炸金花开牌结果
    private static Map<String, Integer> sHaiDaoResult;//海盗船长开牌结果
    private static Map<String, Integer> sNiuZaiResult;//开心牛仔开牌结果
    private static Map<String, Integer> sEbbResult;//二八贝开牌结果
    private static Map<String, Integer> sEbbDianResult;//二八贝点数
    private static SparseIntArray sZpResult;//转盘结果

    static {
        sGameIconMap = new SparseIntArray();
        sGameIconMap.put(1, R.mipmap.icon_zjh);
        sGameIconMap.put(2, R.mipmap.icon_hd);
        sGameIconMap.put(3, R.mipmap.icon_zp);
        sGameIconMap.put(4, R.mipmap.icon_nz);
        sGameIconMap.put(5, R.mipmap.icon_ebb);

        sGameNameMap = new SparseIntArray();
        sGameNameMap.put(1, R.string.game_zjh);
        sGameNameMap.put(2, R.string.game_hd);
        sGameNameMap.put(3, R.string.game_zp);
        sGameNameMap.put(4, R.string.game_nz);
        sGameNameMap.put(5, R.string.game_ebb);

        sPokerMap = new HashMap<>();
        sPokerMap.put("1-1", R.mipmap.p1_01);
        sPokerMap.put("1-2", R.mipmap.p1_02);
        sPokerMap.put("1-3", R.mipmap.p1_03);
        sPokerMap.put("1-4", R.mipmap.p1_04);
        sPokerMap.put("1-5", R.mipmap.p1_05);
        sPokerMap.put("1-6", R.mipmap.p1_06);
        sPokerMap.put("1-7", R.mipmap.p1_07);
        sPokerMap.put("1-8", R.mipmap.p1_08);
        sPokerMap.put("1-9", R.mipmap.p1_09);
        sPokerMap.put("1-10", R.mipmap.p1_10);
        sPokerMap.put("1-11", R.mipmap.p1_11);
        sPokerMap.put("1-12", R.mipmap.p1_12);
        sPokerMap.put("1-13", R.mipmap.p1_13);
        sPokerMap.put("1-14", R.mipmap.p1_01);

        sPokerMap.put("2-1", R.mipmap.p2_01);
        sPokerMap.put("2-2", R.mipmap.p2_02);
        sPokerMap.put("2-3", R.mipmap.p2_03);
        sPokerMap.put("2-4", R.mipmap.p2_04);
        sPokerMap.put("2-5", R.mipmap.p2_05);
        sPokerMap.put("2-6", R.mipmap.p2_06);
        sPokerMap.put("2-7", R.mipmap.p2_07);
        sPokerMap.put("2-8", R.mipmap.p2_08);
        sPokerMap.put("2-9", R.mipmap.p2_09);
        sPokerMap.put("2-10", R.mipmap.p2_10);
        sPokerMap.put("2-11", R.mipmap.p2_11);
        sPokerMap.put("2-12", R.mipmap.p2_12);
        sPokerMap.put("2-13", R.mipmap.p2_13);
        sPokerMap.put("2-14", R.mipmap.p2_01);

        sPokerMap.put("3-1", R.mipmap.p3_01);
        sPokerMap.put("3-2", R.mipmap.p3_02);
        sPokerMap.put("3-3", R.mipmap.p3_03);
        sPokerMap.put("3-4", R.mipmap.p3_04);
        sPokerMap.put("3-5", R.mipmap.p3_05);
        sPokerMap.put("3-6", R.mipmap.p3_06);
        sPokerMap.put("3-7", R.mipmap.p3_07);
        sPokerMap.put("3-8", R.mipmap.p3_08);
        sPokerMap.put("3-9", R.mipmap.p3_09);
        sPokerMap.put("3-10", R.mipmap.p3_10);
        sPokerMap.put("3-11", R.mipmap.p3_11);
        sPokerMap.put("3-12", R.mipmap.p3_12);
        sPokerMap.put("3-13", R.mipmap.p3_13);
        sPokerMap.put("3-14", R.mipmap.p3_01);

        sPokerMap.put("4-1", R.mipmap.p4_01);
        sPokerMap.put("4-2", R.mipmap.p4_02);
        sPokerMap.put("4-3", R.mipmap.p4_03);
        sPokerMap.put("4-4", R.mipmap.p4_04);
        sPokerMap.put("4-5", R.mipmap.p4_05);
        sPokerMap.put("4-6", R.mipmap.p4_06);
        sPokerMap.put("4-7", R.mipmap.p4_07);
        sPokerMap.put("4-8", R.mipmap.p4_08);
        sPokerMap.put("4-9", R.mipmap.p4_09);
        sPokerMap.put("4-10", R.mipmap.p4_10);
        sPokerMap.put("4-11", R.mipmap.p4_11);
        sPokerMap.put("4-12", R.mipmap.p4_12);
        sPokerMap.put("4-13", R.mipmap.p4_13);
        sPokerMap.put("4-14", R.mipmap.p4_01);


        sJinHuaResult = new HashMap<>();
        sJinHuaResult.put("1", R.mipmap.icon_zjh_result_dp);//单牌
        sJinHuaResult.put("2", R.mipmap.icon_zjh_result_dz);//对子
        sJinHuaResult.put("3", R.mipmap.icon_zjh_result_sz);//顺子
        sJinHuaResult.put("4", R.mipmap.icon_zjh_result_th);//同花
        sJinHuaResult.put("5", R.mipmap.icon_zjh_result_ths);//同花顺
        sJinHuaResult.put("6", R.mipmap.icon_zjh_result_bz);//豹子

        sHaiDaoResult = new HashMap();
        sHaiDaoResult.put("0", R.mipmap.icon_hd_result_mn);//没牛
        sHaiDaoResult.put("1", R.mipmap.icon_hd_result_ny);//牛一
        sHaiDaoResult.put("2", R.mipmap.icon_hd_result_ne);//牛二
        sHaiDaoResult.put("3", R.mipmap.icon_hd_result_ns);//牛三
        sHaiDaoResult.put("4", R.mipmap.icon_hd_result_nsi);//牛四
        sHaiDaoResult.put("5", R.mipmap.icon_hd_result_nw);//牛五
        sHaiDaoResult.put("6", R.mipmap.icon_hd_result_nl);//牛六
        sHaiDaoResult.put("7", R.mipmap.icon_hd_result_nq);//牛七
        sHaiDaoResult.put("8", R.mipmap.icon_hd_result_nb);//牛八
        sHaiDaoResult.put("9", R.mipmap.icon_hd_result_nj);//牛九
        sHaiDaoResult.put("10", R.mipmap.icon_hd_result_nn);//牛牛
        sHaiDaoResult.put("11", R.mipmap.icon_hd_result_shn);//四花牛
        sHaiDaoResult.put("12", R.mipmap.icon_hd_result_whn);//五花牛
        sHaiDaoResult.put("13", R.mipmap.icon_hd_result_wxn);//五小牛

        sNiuZaiResult = new HashMap<>();
        sNiuZaiResult.put("10", R.mipmap.icon_nz_result_lose_00);
        sNiuZaiResult.put("11", R.mipmap.icon_nz_result_lose_01);
        sNiuZaiResult.put("12", R.mipmap.icon_nz_result_lose_02);
        sNiuZaiResult.put("13", R.mipmap.icon_nz_result_lose_03);
        sNiuZaiResult.put("14", R.mipmap.icon_nz_result_lose_04);
        sNiuZaiResult.put("15", R.mipmap.icon_nz_result_lose_05);
        sNiuZaiResult.put("16", R.mipmap.icon_nz_result_lose_06);
        sNiuZaiResult.put("17", R.mipmap.icon_nz_result_lose_07);
        sNiuZaiResult.put("18", R.mipmap.icon_nz_result_lose_08);
        sNiuZaiResult.put("19", R.mipmap.icon_nz_result_lose_09);
        sNiuZaiResult.put("110", R.mipmap.icon_nz_result_lose_10);

        sNiuZaiResult.put("20", R.mipmap.icon_nz_result_ping_00);
        sNiuZaiResult.put("21", R.mipmap.icon_nz_result_ping_01);
        sNiuZaiResult.put("22", R.mipmap.icon_nz_result_ping_02);
        sNiuZaiResult.put("23", R.mipmap.icon_nz_result_ping_03);
        sNiuZaiResult.put("24", R.mipmap.icon_nz_result_ping_04);
        sNiuZaiResult.put("25", R.mipmap.icon_nz_result_ping_05);
        sNiuZaiResult.put("26", R.mipmap.icon_nz_result_ping_06);
        sNiuZaiResult.put("27", R.mipmap.icon_nz_result_ping_07);
        sNiuZaiResult.put("28", R.mipmap.icon_nz_result_ping_08);
        sNiuZaiResult.put("29", R.mipmap.icon_nz_result_ping_09);
        sNiuZaiResult.put("210", R.mipmap.icon_nz_result_ping_10);

        sNiuZaiResult.put("30", R.mipmap.icon_nz_result_win_00);
        sNiuZaiResult.put("31", R.mipmap.icon_nz_result_win_01);
        sNiuZaiResult.put("32", R.mipmap.icon_nz_result_win_02);
        sNiuZaiResult.put("33", R.mipmap.icon_nz_result_win_03);
        sNiuZaiResult.put("34", R.mipmap.icon_nz_result_win_04);
        sNiuZaiResult.put("35", R.mipmap.icon_nz_result_win_05);
        sNiuZaiResult.put("36", R.mipmap.icon_nz_result_win_06);
        sNiuZaiResult.put("37", R.mipmap.icon_nz_result_win_07);
        sNiuZaiResult.put("38", R.mipmap.icon_nz_result_win_08);
        sNiuZaiResult.put("39", R.mipmap.icon_nz_result_win_09);
        sNiuZaiResult.put("310", R.mipmap.icon_nz_result_win_10);

        sEbbResult = new HashMap<>();
        sEbbResult.put("0", R.mipmap.icon_ebb_result_00);
        sEbbResult.put("1", R.mipmap.icon_ebb_result_01);
        sEbbResult.put("2", R.mipmap.icon_ebb_result_02);
        sEbbResult.put("3", R.mipmap.icon_ebb_result_03);
        sEbbResult.put("4", R.mipmap.icon_ebb_result_04);
        sEbbResult.put("5", R.mipmap.icon_ebb_result_05);
        sEbbResult.put("6", R.mipmap.icon_ebb_result_06);
        sEbbResult.put("7", R.mipmap.icon_ebb_result_07);
        sEbbResult.put("8", R.mipmap.icon_ebb_result_08);
        sEbbResult.put("9", R.mipmap.icon_ebb_result_09);
        sEbbResult.put("10", R.mipmap.icon_ebb_result_bz);
        sEbbResult.put("11", R.mipmap.icon_ebb_result_10);

        sEbbDianResult = new HashMap<>();
        sEbbDianResult.put("0", R.mipmap.icon_ebb_result_d0);
        sEbbDianResult.put("1", R.mipmap.icon_ebb_result_d1);
        sEbbDianResult.put("2", R.mipmap.icon_ebb_result_d2);
        sEbbDianResult.put("3", R.mipmap.icon_ebb_result_d3);
        sEbbDianResult.put("4", R.mipmap.icon_ebb_result_d4);
        sEbbDianResult.put("5", R.mipmap.icon_ebb_result_d5);
        sEbbDianResult.put("6", R.mipmap.icon_ebb_result_d6);
        sEbbDianResult.put("7", R.mipmap.icon_ebb_result_d7);
        sEbbDianResult.put("8", R.mipmap.icon_ebb_result_d8);
        sEbbDianResult.put("9", R.mipmap.icon_ebb_result_d9);

        sZpResult = new SparseIntArray();
        sZpResult.put(1, R.mipmap.icon_zp_1);
        sZpResult.put(2, R.mipmap.icon_zp_2);
        sZpResult.put(3, R.mipmap.icon_zp_3);
        sZpResult.put(4, R.mipmap.icon_zp_4);

    }

    public static int getGameIcon(int key) {
        return sGameIconMap.get(key);
    }

    public static int getGameName(int key) {
        return sGameNameMap.get(key);
    }

    /**
     * 获取扑克牌
     */
    public static int getPoker(String key) {
        return sPokerMap.get(key);
    }

    /**
     * 炸金花游戏的结果
     */
    public static int getJinHuaResult(String key) {
        return sJinHuaResult.get(key);
    }

    /**
     * 海盗船长游戏的结果
     */
    public static int getHaiDaoResult(String key) {
        return sHaiDaoResult.get(key);
    }

    /**
     * 开心牛仔的结果
     */
    public static int getNiuZaiResult(String key) {
        return sNiuZaiResult.get(key);
    }

    /**
     * 二八贝的结果
     */
    public static int getEbbResult(String key) {
        return sEbbResult.get(key);
    }


    /**
     * 二八贝的点数
     */
    public static int getEbbDianResult(String key) {
        return sEbbDianResult.get(key);
    }

    /**
     * 转盘的结果
     */
    public static int getLuckPanResult(int key) {
        return sZpResult.get(key);
    }
}
