package com.feiyu.main.dialog;

import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.main.R;
import com.feiyu.main.interfaces.MainStartChooseCallback;

/**
 * Created by cxf on 2018/9/29.
 */

public class MainStartDialogFragment extends AbsDialogFragment implements View.OnClickListener {

    private MainStartChooseCallback mCallback;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_main_start;
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
        window.setWindowAnimations(R.style.bottomToTopAnim);
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.BOTTOM;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mRootView.findViewById(R.id.btn_live).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_video).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_close).setOnClickListener(this);
    }

    public void setMainStartChooseCallback(MainStartChooseCallback callback) {
        mCallback = callback;
    }

    @Override
    public void onClick(View v) {
        if(!canClick()){
            return;
        }
        dismiss();
        int i = v.getId();
        if (i == R.id.btn_close) {
        } else if (i == R.id.btn_live) {
            if (mCallback != null) {
                mCallback.onLiveClick();
            }
        } else if (i == R.id.btn_video) {
            if (mCallback != null) {
                mCallback.onVideoClick();
            }
        }
    }

}
