package com.feiyu.game.dialog;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.Constants;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.event.CoinChangeEvent;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.DialogUitl;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.game.R;
import com.feiyu.game.adapter.GameNzSzAdapter;
import com.feiyu.game.bean.GameNzSzBean;
import com.feiyu.game.http.GameHttpConsts;
import com.feiyu.game.http.GameHttpUtil;

import org.greenrobot.eventbus.EventBus;

import java.util.Arrays;
import java.util.List;

/**
 * Created by cxf on 2018/11/5.
 * 开心牛仔上庄列表
 */

public class GameNzSzDialogFragment extends AbsDialogFragment implements View.OnClickListener {

    private RecyclerView mRecyclerView;
    private TextView mBtnApplySz;//申请上下庄的按钮
    private boolean mSz;//是否上庄了
    private String mStream;
    private String mBankerLimitString;//最低上庄押金

    @Override
    protected int getLayoutId() {
        return R.layout.game_dialog_nz_sz;
    }

    @Override
    protected int getDialogStyle() {
        return R.style.dialog2;
    }

    @Override
    protected boolean canCancel() {
        return false;
    }

    @Override
    protected void setWindowAttributes(Window window) {
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = DpUtil.dp2px(280);
        params.height = DpUtil.dp2px(360);
        params.gravity = Gravity.CENTER;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        Bundle bundle = getArguments();
        if (bundle == null) {
            return;
        }
        mStream = bundle.getString(Constants.STREAM);
        if (TextUtils.isEmpty(mStream)) {
            return;
        }
        mBankerLimitString = bundle.getString(Constants.LIMIT);
        mBtnApplySz = mRootView.findViewById(R.id.btn_apply_sz);
        mRecyclerView = mRootView.findViewById(R.id.recyclerView);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false));
        mRootView.findViewById(R.id.btn_close).setOnClickListener(this);
        GameHttpUtil.gameNiuGetBanker(mStream, new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0) {
                    List<GameNzSzBean> list = JSON.parseArray(Arrays.toString(info), GameNzSzBean.class);
                    if (list.size() >= 2) {
                        for (int i = 0; i < list.size(); i++) {
                            if ("0".equals(list.get(i).getId())) {
                                list.remove(i);
                                break;
                            }
                        }
                    }
                    if (list.size() > 0) {
                        GameNzSzAdapter adapter = new GameNzSzAdapter(mContext, list);
                        mRecyclerView.setAdapter(adapter);
                    }
                    String uid = CommonAppConfig.getInstance().getUid();
                    if (!TextUtils.isEmpty(uid)) {
                        for (GameNzSzBean bean : list) {
                            if (uid.equals(bean.getId())) {
                                mSz = true;
                                break;
                            }
                        }
                        if (mSz) {
                            mBtnApplySz.setText(R.string.game_nz_apply_sz_2);
                        } else {
                            mBtnApplySz.setText(R.string.game_nz_apply_sz_1);
                        }
                        mBtnApplySz.setOnClickListener(GameNzSzDialogFragment.this);
                    }
                } else {
                    ToastUtil.show(msg);
                }
            }
        });
    }


    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.btn_close) {
            dismiss();

        } else if (i == R.id.btn_apply_sz) {
            if (mSz) {
                xiaZhuang();
            } else {
                shangZhuang();
            }

        }

    }


    /**
     * 上庄
     */
    private void shangZhuang() {
        DialogUitl.showSimpleInputDialog(mContext, WordUtil.getString(R.string.game_nz_apply_sz_yajin),
                mBankerLimitString, DialogUitl.INPUT_TYPE_NUMBER, 9,new DialogUitl.SimpleCallback() {
                    @Override
                    public void onConfirmClick(final Dialog dialog, String content) {
                        if (TextUtils.isEmpty(content)) {
                            ToastUtil.show(R.string.game_nz_apply_sz_yajin_empty);
                            return;
                        }
                        GameHttpUtil.gameNiuSetBanker(mStream, content, new HttpCallback() {
                            @Override
                            public void onSuccess(int code, String msg, String[] info) {
                                if (info.length > 0 && info.length > 0) {
                                    JSONObject obj = JSON.parseObject(info[0]);
                                    EventBus.getDefault().post(new CoinChangeEvent(obj.getString("coin")));
                                    ToastUtil.show(obj.getString("msg"));
                                    dialog.dismiss();
                                    GameNzSzDialogFragment.this.dismiss();
                                } else {
                                    ToastUtil.show(msg);
                                }
                            }
                        });
                    }
                }
        );
    }

    /**
     * 下庄
     */
    private void xiaZhuang() {
        GameHttpUtil.gameNiuQuitBanker(mStream, new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0 && info.length > 0) {
                    ToastUtil.show(JSON.parseObject(info[0]).getString("msg"));
                    dismiss();
                } else {
                    ToastUtil.show(msg);
                }
            }
        });
    }


    @Override
    public void onDestroy() {
        GameHttpUtil.cancel(GameHttpConsts.GAME_NIU_GET_BANKER);
        GameHttpUtil.cancel(GameHttpConsts.GAME_NIU_SET_BANKER);
        GameHttpUtil.cancel(GameHttpConsts.GAME_NIU_QUIT_BANKER);
        super.onDestroy();
    }
}
