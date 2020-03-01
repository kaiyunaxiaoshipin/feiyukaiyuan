package com.feiyu.game.event;

/**
 * Created by cxf on 2019/3/21.
 */

public class GameWindowChangedEvent {

    private boolean mOpen;
    private int mGameViewHeight;

    public GameWindowChangedEvent(boolean open, int gameViewHeight) {
        mOpen = open;
        mGameViewHeight = gameViewHeight;
    }

    public int getGameViewHeight() {
        return mGameViewHeight;
    }

    public boolean isOpen() {
        return mOpen;
    }
}
