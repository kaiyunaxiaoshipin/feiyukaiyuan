package com.feiyu.live.dialog;

import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;
import com.feiyu.live.http.LiveHttpConsts;
import com.feiyu.live.http.LiveHttpUtil;

/**
 * Created by cxf on 2019/4/30.
 */

public class GiftPrizePoolFragment extends AbsDialogFragment implements View.OnClickListener {

    private TextView mLevel;
    private TextView mCoin;
    private String mLiveUid;
    private String mStream;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_gift_prize_pool;
    }

    @Override
    protected int getDialogStyle() {
        return R.style.dialog2;
    }

    @Override
    protected boolean canCancel() {
        return true;
    }

    @Override
    protected void setWindowAttributes(Window window) {
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = DpUtil.dp2px(280);
        params.height = DpUtil.dp2px(240);
        params.y = -DpUtil.dp2px(70);
        params.gravity = Gravity.CENTER;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mLevel = (TextView) findViewById(R.id.level);
        mCoin = (TextView) findViewById(R.id.coin);
        findViewById(R.id.btn_close).setOnClickListener(this);
        LiveHttpUtil.getLiveGiftPrizePool(mLiveUid, mStream, new HttpCallback() {

            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0 && info.length > 0) {
                    JSONObject obj = JSON.parseObject(info[0]);
                    if (mLevel != null) {
                        mLevel.setText(String.format(WordUtil.getString(R.string.live_gift_prize_pool_3),
                                obj.getString("level")));
                    }
                    if (mCoin != null) {
                        mCoin.setText(obj.getString("total"));
                    }
                }
            }
        });
    }


    public String getLiveUid() {
        return mLiveUid;
    }

    public void setLiveUid(String liveUid) {
        mLiveUid = liveUid;
    }

    public String getStream() {
        return mStream;
    }

    public void setStream(String stream) {
        mStream = stream;
    }

    @Override
    public void onDestroy() {
        LiveHttpUtil.cancel(LiveHttpConsts.GET_LIVE_GIFT_PRIZE_POOL);
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }
}



