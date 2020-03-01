package com.feiyu.live.socket;

import com.feiyu.game.GameConsts;
import com.feiyu.game.interfaces.GameActionListener;
import com.feiyu.live.activity.LiveActivity;

/**
 * Created by cxf on 2019/3/22.
 */

public class GameActionListenerImpl implements GameActionListener {

    private LiveActivity mLiveActivity;
    private SocketClient mSocketClient;

    public GameActionListenerImpl(LiveActivity liveActivity, SocketClient socketClient) {
        mLiveActivity = liveActivity;
        mSocketClient = socketClient;
    }


    @Override
    public void onGamePlayChanged(boolean playing) {
        if (mLiveActivity != null) {
            mLiveActivity.setGamePlaying(playing);
        }
    }

    @Override
    public boolean isLinkMicIng() {
        if (mLiveActivity != null) {
            return mLiveActivity.isLinkMic() || mLiveActivity.isLinkMicAnchor();
        }
        return false;
    }

    @Override
    public void showGameWindow(int gameAction) {
        switch (gameAction) {
            case GameConsts.GAME_ACTION_ZJH:
                SocketGameUtil.zjhShowGameWindow(mSocketClient);
                break;
            case GameConsts.GAME_ACTION_HD:
                SocketGameUtil.hdShowGameWindow(mSocketClient);
                break;
            case GameConsts.GAME_ACTION_ZP:
                SocketGameUtil.zpShowGameWindow(mSocketClient);
                break;
            case GameConsts.GAME_ACTION_NZ:
                SocketGameUtil.nzShowGameWindow(mSocketClient);
                break;
            case GameConsts.GAME_ACTION_EBB:
                SocketGameUtil.ebbShowGameWindow(mSocketClient);
                break;
        }
    }

    @Override
    public void zjhShowGameWindow() {
        SocketGameUtil.zjhShowGameWindow(mSocketClient);
    }

    @Override
    public void zjhAnchorCreateGame(String gameId) {
        SocketGameUtil.zjhAnchorCreateGame(mSocketClient, gameId);
    }

    @Override
    public void zjhAnchorCloseGame() {
        SocketGameUtil.zjhAnchorCloseGame(mSocketClient);
    }

    @Override
    public void zjhAnchorNotifyGameBet(String liveUid, String gameId, String token, int time) {
        SocketGameUtil.zjhAnchorNotifyGameBet(mSocketClient, liveUid, gameId, token, time);
    }

    @Override
    public void zjhAudienceBetGame(int coin, int index) {
        SocketGameUtil.zjhAudienceBetGame(mSocketClient, coin, index);
    }

    @Override
    public void hdShowGameWindow() {
        SocketGameUtil.hdShowGameWindow(mSocketClient);
    }

    @Override
    public void hdAnchorCreateGame(String gameId) {
        SocketGameUtil.hdAnchorCreateGame(mSocketClient, gameId);
    }

    @Override
    public void hdAnchorCloseGame() {
        SocketGameUtil.hdAnchorCloseGame(mSocketClient);
    }

    @Override
    public void hdAnchorNotifyGameBet(String liveUid, String gameId, String token, int time) {
        SocketGameUtil.hdAnchorNotifyGameBet(mSocketClient, liveUid, gameId, token, time);
    }

    @Override
    public void hdAudienceBetGame(int coin, int index) {
        SocketGameUtil.hdAudienceBetGame(mSocketClient, coin, index);
    }

    @Override
    public void zpShowGameWindow() {
        SocketGameUtil.zpShowGameWindow(mSocketClient);
    }

    @Override
    public void zpAnchorCloseGame() {
        SocketGameUtil.zpAnchorCloseGame(mSocketClient);
    }

    @Override
    public void zpAnchorNotifyGameBet(String liveUid, String gameId, String token, int time) {
        SocketGameUtil.zpAnchorNotifyGameBet(mSocketClient, liveUid, gameId, token, time);
    }

    @Override
    public void zpAudienceBetGame(int coin, int index) {
        SocketGameUtil.zpAudienceBetGame(mSocketClient, coin, index);
    }

    @Override
    public void nzShowGameWindow() {
        SocketGameUtil.nzShowGameWindow(mSocketClient);
    }

    @Override
    public void nzAnchorCreateGame(String gameId, String bankerInfo) {
        SocketGameUtil.nzAnchorCreateGame(mSocketClient, gameId, bankerInfo);
    }

    @Override
    public void nzAnchorCloseGame() {
        SocketGameUtil.nzAnchorCloseGame(mSocketClient);
    }

    @Override
    public void nzAnchorNotifyGameBet(String liveUid, String gameId, String token, int time) {
        SocketGameUtil.nzAnchorNotifyGameBet(mSocketClient, liveUid, gameId, token, time);
    }

    @Override
    public void nzAudienceBetGame(int coin, int index) {
        SocketGameUtil.nzAudienceBetGame(mSocketClient, coin, index);
    }

    @Override
    public void ebbShowGameWindow() {
        SocketGameUtil.ebbShowGameWindow(mSocketClient);
    }

    @Override
    public void ebbAnchorCreateGame(String gameId) {
        SocketGameUtil.ebbAnchorCreateGame(mSocketClient, gameId);
    }

    @Override
    public void ebbAnchorCloseGame() {
        SocketGameUtil.ebbAnchorCloseGame(mSocketClient);
    }

    @Override
    public void ebbAnchorNotifyGameBet(String liveUid, String gameId, String token, int time) {
        SocketGameUtil.ebbAnchorNotifyGameBet(mSocketClient, liveUid, gameId, gameId, time);
    }

    @Override
    public void ebbAudienceBetGame(int coin, int index) {
        SocketGameUtil.ebbAudienceBetGame(mSocketClient, coin, index);
    }

    @Override
    public void release() {
        mSocketClient = null;
        mLiveActivity = null;
    }
}
