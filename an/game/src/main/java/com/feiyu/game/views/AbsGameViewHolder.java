package com.feiyu.game.views;

import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.utils.RouteUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.common.views.AbsViewHolder;
import com.feiyu.game.R;
import com.feiyu.game.bean.GameParam;
import com.feiyu.game.event.GameWindowChangedEvent;
import com.feiyu.game.interfaces.GameActionListener;
import com.feiyu.game.util.GameSoundPool;

import org.greenrobot.eventbus.EventBus;

/**
 * Created by cxf on 2018/10/31.
 */

public abstract class AbsGameViewHolder extends AbsViewHolder implements View.OnClickListener {

    protected Context mContext;
    protected String mTag;
    protected String mCoinName;
    protected String mChargeString;
    protected int mBetMoney;//每次下注的量
    protected String mLiveUid;
    protected String mStream;
    protected View mTopView;
    protected int mGameViewHeight;//游戏部分的高度
    protected boolean mAnchor;
    protected boolean mShowed;
    protected GameActionListener mGameActionListener;
    protected GameSoundPool mGameSoundPool;
    protected boolean mEnd;
    protected String mGameID;
    protected String mGameToken;
    protected int mBetTime;
    protected int[] mTotalBet;
    protected int[] mMyBet;
    protected boolean mBetStarted;


    public AbsGameViewHolder(GameParam gameParam, GameSoundPool gameSoundPool) {
        super(gameParam.getContext(), gameParam.getParentView());
        mContext = gameParam.getContext();
        mTopView = gameParam.getTopView();
        mGameActionListener = gameParam.getGameActionListener();
        mLiveUid = gameParam.getLiveUid();
        mStream = gameParam.getStream();
        mAnchor = gameParam.isAnchor();
        mCoinName = gameParam.getCoinName();
        mGameSoundPool = gameSoundPool;
        mTag = getClass().getSimpleName();
        mChargeString = WordUtil.getString(R.string.game_charge);
    }

    /**
     * 显示游戏窗口
     */
    public void showGameWindow() {
        FrameLayout.LayoutParams params = (FrameLayout.LayoutParams) mTopView.getLayoutParams();
        params.setMargins(0, 0, 0, mGameViewHeight);
        mTopView.setLayoutParams(params);
        addToParent();
        EventBus.getDefault().post(new GameWindowChangedEvent(true, mGameViewHeight));
    }

    /**
     * 隐藏游戏窗口
     */
    public void hideGameWindow() {
        if (mShowed) {
            removeFromParent();
            FrameLayout.LayoutParams params = (FrameLayout.LayoutParams) mTopView.getLayoutParams();
            params.setMargins(0, 0, 0, 0);
            mTopView.setLayoutParams(params);
            EventBus.getDefault().post(new GameWindowChangedEvent(false, 0));
        }
    }

    /**
     * 播放游戏音效
     */
    protected void playGameSound(int key) {
        if (mGameSoundPool != null) {
            mGameSoundPool.play(key);
        }
    }

    public abstract void handleSocket(int action, JSONObject obj);

    /**
     * 主播创建游戏
     */
    protected abstract void anchorCreateGame();

    /**
     * 观众进入直播间，如果游戏正在进行，则打开游戏窗口
     */
    public abstract void enterRoomOpenGameWindow();

    /**
     * 主播关闭游戏
     */
    public abstract void anchorCloseGame();


    /**
     * 观众获取游戏的结果  输赢等
     */
    protected abstract void getGameResult();

    /**
     * 开始下次游戏
     */
    protected abstract void nextGame();

    /**
     * 设置剩余的钻石
     */
    public abstract void setLastCoin(String coin);


    public void release() {
        mGameSoundPool = null;
        mContext = null;
        mParentView = null;
        mTopView = null;
        mGameActionListener = null;
        mLiveUid = null;
        mStream = null;
    }


    @Override
    public void addToParent() {
        super.addToParent();
        mShowed = true;
    }

    @Override
    public void removeFromParent() {
        super.removeFromParent();
        mShowed = false;
    }

    /**
     * 前往充值
     */
    protected void forwardCharge() {
        RouteUtil.forwardMyCoin(mContext);
    }

    public void setGameID(String gameID) {
        mGameID = gameID;
    }

    public void setGameToken(String gameToken) {
        mGameToken = gameToken;
    }

    public void setBetTime(int betTime) {
        mBetTime = betTime;
    }

    public void setTotalBet(int[] totalBet) {
        mTotalBet = totalBet;
    }

    public void setMyBet(int[] myBet) {
        mMyBet = myBet;
    }

    public boolean isBetStarted() {
        return mBetStarted;
    }
}
