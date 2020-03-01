package com.feiyu.game.http;

import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.http.HttpClient;

/**
 * Created by cxf on 2018/9/17.
 */

public class GameHttpUtil {

    /**
     * 取消网络请求
     */
    public static void cancel(String tag) {
        HttpClient.getInstance().cancel(tag);
    }
    
    /**
     * 创建炸金花游戏
     */
    public static void gameJinhuaCreate(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Jinhua", GameHttpConsts.GAME_JINHUA_CREATE)
                .params("liveuid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 炸金花游戏下注
     */
    public static void gameJinhuaBet(String gameid, int coin, int grade, HttpCallback callback) {
        HttpClient.getInstance().get("Game.JinhuaBet", GameHttpConsts.GAME_JINHUA_BET)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("gameid", gameid)
                .params("coin", coin)
                .params("grade", grade)
                .execute(callback);
    }

    /**
     * 游戏结果出来后，观众获取自己赢到的金额
     */
    public static void gameSettle(String gameid, HttpCallback callback) {
        HttpClient.getInstance().get("Game.settleGame", GameHttpConsts.GAME_SETTLE)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("gameid", gameid)
                .execute(callback);
    }

    /**
     * 创建海盗船长游戏
     */
    public static void gameHaidaoCreate(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Taurus", GameHttpConsts.GAME_HAIDAO_CREATE)
                .params("liveuid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 海盗船长游戏下注
     */
    public static void gameHaidaoBet(String gameid, int coin, int grade, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Taurus_Bet", GameHttpConsts.GAME_HAIDAO_BET)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("gameid", gameid)
                .params("coin", coin)
                .params("grade", grade)
                .execute(callback);
    }

    /**
     * 创建幸运转盘游戏
     */
    public static void gameLuckPanCreate(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Dial", GameHttpConsts.GAME_LUCK_PAN_CREATE)
                .params("liveuid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 幸运转盘游戏下注
     */
    public static void gameLuckPanBet(String gameid, int coin, int grade, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Dial_Bet", GameHttpConsts.GAME_LUCK_PAN_BET)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("gameid", gameid)
                .params("coin", coin)
                .params("grade", grade)
                .execute(callback);
    }

    /**
     * 创建开心牛仔游戏
     */
    public static void gameNiuzaiCreate(String stream, String bankerid, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Cowboy", GameHttpConsts.GAME_NIUZAI_CREATE)
                .params("liveuid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .params("bankerid", bankerid)
                .execute(callback);
    }

    /**
     * 开心牛仔游戏下注
     */
    public static void gameNiuzaiBet(String gameid, int coin, int grade, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Cowboy_Bet", GameHttpConsts.GAME_NIUZAI_BET)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("gameid", gameid)
                .params("coin", coin)
                .params("grade", grade)
                .execute(callback);
    }

    /**
     * 开心牛仔游戏胜负记录
     */
    public static void gameNiuRecord(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.getGameRecord", GameHttpConsts.GAME_NIU_RECORD)
                .params("action", "4")
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 开心牛仔庄家流水
     */
    public static void gameNiuBankerWater(String bankerId, String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.getBankerProfit", GameHttpConsts.GAME_NIU_BANKER_WATER)
                .params("bankerid", bankerId)
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 开心牛仔获取庄家列表,列表第一个为当前庄家
     */
    public static void gameNiuGetBanker(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.getBanker", GameHttpConsts.GAME_NIU_GET_BANKER)
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 开心牛仔申请上庄
     */
    public static void gameNiuSetBanker(String stream, String deposit, HttpCallback callback) {
        HttpClient.getInstance().get("Game.setBanker", GameHttpConsts.GAME_NIU_SET_BANKER)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .params("deposit", deposit)
                .execute(callback);
    }

    /**
     * 开心牛仔申请下庄
     */
    public static void gameNiuQuitBanker(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.quietBanker", GameHttpConsts.GAME_NIU_QUIT_BANKER)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 创建二八贝游戏
     */
    public static void gameEbbCreate(String stream, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Cowry", GameHttpConsts.GAME_EBB_CREATE)
                .params("liveuid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("stream", stream)
                .execute(callback);
    }

    /**
     * 二八贝下注
     */
    public static void gameEbbBet(String gameid, int coin, int grade, HttpCallback callback) {
        HttpClient.getInstance().get("Game.Cowry_Bet", GameHttpConsts.GAME_EBB_BET)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .params("gameid", gameid)
                .params("coin", coin)
                .params("grade", grade)
                .execute(callback);
    }

    /**
     * 获取用户余额
     */
    public static void getCoin(HttpCallback callback) {
        HttpClient.getInstance().get("Live.getCoin", GameHttpConsts.GET_COIN)
                .params("uid", CommonAppConfig.getInstance().getUid())
                .params("token", CommonAppConfig.getInstance().getToken())
                .execute(callback);
    }

}




