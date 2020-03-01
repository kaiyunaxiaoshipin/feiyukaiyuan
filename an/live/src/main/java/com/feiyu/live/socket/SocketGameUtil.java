package com.feiyu.live.socket;

import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.Constants;
import com.feiyu.common.bean.UserBean;
import com.feiyu.game.GameConsts;

/**
 * Created by cxf on 2018/10/31.
 */

public class SocketGameUtil {


    /**
     * 智勇三张 开启游戏窗口
     */
    public static void zjhShowGameWindow(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZJH)
                .param("action", GameConsts.GAME_ACTION_OPEN_WINDOW)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 智勇三张 主播创建游戏
     */
    public static void zjhAnchorCreateGame(SocketClient client, String gameId) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZJH)
                .param("action", GameConsts.GAME_ACTION_CREATE)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("gameid", gameId)
                .param("ct", "")
        );
    }

    /**
     * 智勇三张 主播关闭游戏
     */
    public static void zjhAnchorCloseGame(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZJH)
                .param("action", GameConsts.GAME_ACTION_CLOSE)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 智勇三张 主播通知所有人下注
     * 此时服务器收到该socket后，自动计时，30秒后自动发送显示游戏结果的socket
     */
    public static void zjhAnchorNotifyGameBet(SocketClient client, String liveUid, String gameId, String token, int time) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZJH)
                .param("action", GameConsts.GAME_ACTION_NOTIFY_BET)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("liveuid", liveUid)
                .param("gameid", gameId)
                .param("token", token)
                .param("time", time)
                .param("ct", "")
        );
    }

    /**
     * 智勇三张 观众把自己的下注信息广播给所有人
     */
    public static void zjhAudienceBetGame(SocketClient client, int coin, int index) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZJH)
                .param("action", GameConsts.GAME_ACTION_BROADCAST_BET)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("money", coin)
                .param("type", index)
                .param("ct", "")
        );
    }


    /**
     * 海盗船长 开启游戏窗口
     */
    public static void hdShowGameWindow(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_HD)
                .param("action", 1)
                .param("msgtype", 18)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }


    /**
     * 海盗船长 主播创建游戏
     */
    public static void hdAnchorCreateGame(SocketClient client, String gameId) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_HD)
                .param("action", GameConsts.GAME_ACTION_CREATE)
                .param("msgtype", 18)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("gameid", gameId)
                .param("ct", "")
        );
    }

    /**
     * 海盗船长 主播关闭游戏
     */
    public static void hdAnchorCloseGame(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_HD)
                .param("action", GameConsts.GAME_ACTION_CLOSE)
                .param("msgtype", 18)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }


    /**
     * 海盗船长 主播通知所有人下注
     * 此时服务器收到该socket后，自动计时，30秒后自动发送显示游戏结果的socket
     */
    public static void hdAnchorNotifyGameBet(SocketClient client, String liveUid, String gameId, String token, int time) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_HD)
                .param("action", GameConsts.GAME_ACTION_NOTIFY_BET)
                .param("msgtype", 18)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("liveuid", liveUid)
                .param("gameid", gameId)
                .param("token", token)
                .param("time", time)
                .param("ct", "")
        );
    }

    /**
     * 海盗船长 观众把自己的下注信息广播给所有人
     */
    public static void hdAudienceBetGame(SocketClient client, int coin, int index) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_HD)
                .param("action", GameConsts.GAME_ACTION_BROADCAST_BET)
                .param("msgtype", 18)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("money", coin)
                .param("type", index)
                .param("ct", "")
        );
    }


    /**
     * 幸运转盘 开启游戏窗口
     */
    public static void zpShowGameWindow(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZP)
                .param("action", 1)
                .param("msgtype", 16)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }


    /**
     * 幸运转盘 主播关闭游戏
     */
    public static void zpAnchorCloseGame(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZP)
                .param("action", GameConsts.GAME_ACTION_CLOSE)
                .param("msgtype", 16)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 幸运转盘 主播通知所有人下注
     * 此时服务器收到该socket后，自动计时，30秒后自动发送显示游戏结果的socket
     */
    public static void zpAnchorNotifyGameBet(SocketClient client, String liveUid, String gameId, String token, int time) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZP)
                .param("action", GameConsts.GAME_ACTION_NOTIFY_BET)
                .param("msgtype", 16)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("liveuid", liveUid)
                .param("gameid", gameId)
                .param("token", token)
                .param("time", time)
                .param("ct", "")
        );
    }

    /**
     * 幸运转盘 观众把自己的下注信息广播给所有人
     */
    public static void zpAudienceBetGame(SocketClient client, int coin, int index) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_ZP)
                .param("action", GameConsts.GAME_ACTION_BROADCAST_BET)
                .param("msgtype", 16)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("money", coin)
                .param("type", index)
                .param("ct", "")
        );
    }


    /**
     * 开心牛仔 开启游戏窗口
     */
    public static void nzShowGameWindow(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_NZ)
                .param("action", 1)
                .param("msgtype", 17)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 开心牛仔 主播创建游戏
     * 本局的庄家信息  服务器用"bankerlist" 这个字段表示 ，其实是一个对象，是一个人的信息
     */
    public static void nzAnchorCreateGame(SocketClient client, String gameId, String bankerInfo) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_NZ)
                .param("action", GameConsts.GAME_ACTION_CREATE)
                .param("msgtype", 17)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("gameid", gameId)
                .param("ct", "")
                .paramJsonObject("bankerlist", bankerInfo)
        );
    }

    /**
     * 开心牛仔 主播关闭游戏
     */
    public static void nzAnchorCloseGame(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_NZ)
                .param("action", GameConsts.GAME_ACTION_CLOSE)
                .param("msgtype", 17)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 开心牛仔 主播通知所有人下注
     * 此时服务器收到该socket后，自动计时，30秒后自动发送显示游戏结果的socket
     */
    public static void nzAnchorNotifyGameBet(SocketClient client, String liveUid, String gameId, String token, int time) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_NZ)
                .param("action", GameConsts.GAME_ACTION_NOTIFY_BET)
                .param("msgtype", 17)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("liveuid", liveUid)
                .param("gameid", gameId)
                .param("token", token)
                .param("time", time)
                .param("ct", "")
        );
    }

    /**
     * 开心牛仔 观众把自己的下注信息广播给所有人
     */
    public static void nzAudienceBetGame(SocketClient client, int coin, int index) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_NZ)
                .param("action", GameConsts.GAME_ACTION_BROADCAST_BET)
                .param("msgtype", 17)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("money", coin)
                .param("type", index)
                .param("ct", "")
        );
    }

    /**
     * 二八贝 开启游戏窗口
     */
    public static void ebbShowGameWindow(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_EBB)
                .param("action", 1)
                .param("msgtype", 15)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }

    /**
     * 二八贝 主播创建游戏
     */
    public static void ebbAnchorCreateGame(SocketClient client, String gameId) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_EBB)
                .param("action", GameConsts.GAME_ACTION_CREATE)
                .param("msgtype", 19)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("gameid", gameId)
                .param("ct", "")
        );
    }

    /**
     * 二八贝 主播关闭游戏
     */
    public static void ebbAnchorCloseGame(SocketClient client) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_EBB)
                .param("action", GameConsts.GAME_ACTION_CLOSE)
                .param("msgtype", 19)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("ct", "")
        );
    }


    /**
     * 二八贝 主播通知所有人下注
     * 此时服务器收到该socket后，自动计时，30秒后自动发送显示游戏结果的socket
     */
    public static void ebbAnchorNotifyGameBet(SocketClient client, String liveUid, String gameId, String token, int time) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_EBB)
                .param("action", GameConsts.GAME_ACTION_NOTIFY_BET)
                .param("msgtype", 19)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("liveuid", liveUid)
                .param("gameid", gameId)
                .param("token", token)
                .param("time", time)
                .param("ct", "")
        );
    }

    /**
     * 二八贝 观众把自己的下注信息广播给所有人
     */
    public static void ebbAudienceBetGame(SocketClient client, int coin, int index) {
        if (client == null) {
            return;
        }
        UserBean u = CommonAppConfig.getInstance().getUserBean();
        if (u == null) {
            return;
        }
        client.send(new SocketSendBean()
                .param("_method_", Constants.SOCKET_GAME_EBB)
                .param("action", GameConsts.GAME_ACTION_BROADCAST_BET)
                .param("msgtype", 19)
                .param("level", u.getLevel())
                .param("uname", u.getUserNiceName())
                .param("uid", u.getId())
                .param("money", coin)
                .param("type", index)
                .param("ct", "")
        );
    }


}
