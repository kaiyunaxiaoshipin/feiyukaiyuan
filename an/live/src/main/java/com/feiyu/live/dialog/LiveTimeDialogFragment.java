package com.feiyu.live.dialog;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.feiyu.common.Constants;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.interfaces.CommonCallback;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.live.R;
import com.feiyu.live.adapter.LiveTimeChargeAdapter;

/**
 * Created by cxf on 2018/10/8.
 */

public class LiveTimeDialogFragment extends AbsDialogFragment implements View.OnClickListener {

    private RecyclerView mRecyclerView;
    private LiveTimeChargeAdapter mAdapter;
    private CommonCallback<Integer> mCommonCallback;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_live_room_time;
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
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.CENTER;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mRootView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        Bundle bundle = getArguments();
        if (bundle == null) {
            return;
        }
        int checkedCoin = bundle.getInt(Constants.CHECKED_COIN, 0);
        mRecyclerView =(RecyclerView) mRootView.findViewById(R.id.recyclerView);
        mRecyclerView.setHasFixedSize(true);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false));
        mAdapter = new LiveTimeChargeAdapter(mContext, checkedCoin);
        mRecyclerView.setAdapter(mAdapter);

    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.btn_cancel) {
        } else if (i == R.id.btn_confirm) {
            setCheckedCoin();

        }
        dismiss();
    }

    private void setCheckedCoin() {
        if (mAdapter != null && mCommonCallback != null) {
            mCommonCallback.callback(mAdapter.getCheckedCoin());
        }
    }


    public void setCommonCallback(CommonCallback<Integer> commonCallback) {
        mCommonCallback = commonCallback;
    }

    @Override
    public void onDestroy() {
        mCommonCallback=null;
        super.onDestroy();
    }
}
