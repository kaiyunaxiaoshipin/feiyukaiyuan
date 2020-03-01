package com.feiyu.live.dialog;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;
import com.feiyu.live.adapter.RedPackResultAdapter;
import com.feiyu.live.bean.RedPackBean;
import com.feiyu.live.bean.RedPackResultBean;
import com.feiyu.live.http.LiveHttpUtil;

import java.util.List;

/**
 * Created by cxf on 2018/11/21.
 * 红包领取详情弹窗
 */

public class LiveRedPackResultDialogFragment extends AbsDialogFragment {

    private ImageView mAvatar;
    private TextView mName;
    private TextView mWinCoin;
    private TextView mCoinNameTextView;
    private View mNotWin;
    private View mWinGroup;
    private TextView mNum;
    private RecyclerView mRecyclerView;
    private RedPackBean mRedPackBean;
    private String mStream;
    private String mCoinName;


    @Override
    protected int getLayoutId() {
        return R.layout.dialog_live_red_pack_result;
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
        params.height = DpUtil.dp2px(360);
        params.gravity = Gravity.CENTER;
        window.setAttributes(params);
    }


    public void setRedPackBean(RedPackBean redPackBean) {
        mRedPackBean = redPackBean;
    }

    public void setStream(String stream) {
        mStream = stream;
    }

    public void setCoinName(String coinName) {
        mCoinName = coinName;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (mRedPackBean == null || TextUtils.isEmpty(mStream)) {
            return;
        }
        mAvatar = mRootView.findViewById(R.id.avatar);
        mName = mRootView.findViewById(R.id.name);
        mNotWin = mRootView.findViewById(R.id.not_win);
        mWinGroup = mRootView.findViewById(R.id.win_group);
        mWinCoin = mRootView.findViewById(R.id.win_coin);
        mCoinNameTextView = mRootView.findViewById(R.id.coin_name);
        mNum = mRootView.findViewById(R.id.num);
        mRecyclerView = mRootView.findViewById(R.id.recyclerView);
        mRecyclerView.setHasFixedSize(true);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false));
        LiveHttpUtil.getRedPackResult(mStream, mRedPackBean.getId(), new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0 && info.length > 0) {
                    JSONObject obj = JSON.parseObject(info[0]);
                    JSONObject redPackInfo = obj.getJSONObject("redinfo");
                    if (redPackInfo != null) {
                        if (mAvatar != null) {
                            ImgLoader.displayAvatar(mContext,redPackInfo.getString("avatar"), mAvatar);
                        }
                        if (mName != null) {
                            mName.setText(String.format(WordUtil.getString(R.string.red_pack_17), redPackInfo.getString("user_nicename")));
                        }
                        if (mNum != null) {
                            mNum.setText(String.format(WordUtil.getString(R.string.red_pack_19),
                                    redPackInfo.getString("nums_rob") + "/" + redPackInfo.getString("nums"),
                                    redPackInfo.getString("coin_rob") + "/" + redPackInfo.getString("coin"),
                                    mCoinName));
                        }
                    }
                    String winCoinVal = obj.getString("win");
                    if (TextUtils.isEmpty(winCoinVal) || "0".equals(winCoinVal)) {//没抢到
                        if (mNotWin != null && mNotWin.getVisibility() != View.VISIBLE) {
                            mNotWin.setVisibility(View.VISIBLE);
                        }
                    } else {//抢到了
                        if (mWinGroup != null && mWinGroup.getVisibility() != View.VISIBLE) {
                            mWinGroup.setVisibility(View.VISIBLE);
                        }
                        if (mWinCoin != null) {
                            mWinCoin.setText(winCoinVal);
                        }
                        if (mCoinNameTextView != null) {
                            mCoinNameTextView.setText(String.format(WordUtil.getString(R.string.red_pack_18), mCoinName));
                        }
                    }
                    if (mRecyclerView != null) {
                        List<RedPackResultBean> list = JSON.parseArray(obj.getString("list"), RedPackResultBean.class);
                        RedPackResultAdapter adapter = new RedPackResultAdapter(mContext, list);
                        mRecyclerView.setAdapter(adapter);
                    }
                }
            }
        });
    }
}
