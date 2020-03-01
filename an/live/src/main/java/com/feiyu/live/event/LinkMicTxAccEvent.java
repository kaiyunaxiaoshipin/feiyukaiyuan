package com.feiyu.live.event;

/**
 * Created by cxf on 2019/3/25.
 */

public class LinkMicTxAccEvent {

    private boolean mLinkMic;

    public LinkMicTxAccEvent(boolean linkMic) {
        mLinkMic = linkMic;
    }

    public boolean isLinkMic() {
        return mLinkMic;
    }
}
