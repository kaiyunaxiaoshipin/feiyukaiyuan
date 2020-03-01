package com.feiyu.live.dialog;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.TextView;

import com.feiyu.common.Constants;
import com.feiyu.common.custom.MyRadioButton;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;
import com.feiyu.live.activity.LiveActivity;

/**
 * Created by cxf on 2017/8/21.
 * 直播间发言框
 */

public class LiveInputDialogFragment extends AbsDialogFragment implements View.OnClickListener {

    private InputMethodManager imm;
    private EditText mInput;
    private CheckBox mCheckBox;
    private MyRadioButton mMyRadioButton;
    private String mHint1;
    private String mHint2;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_live_chat_input;
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
        params.height = DpUtil.dp2px(50);
        params.gravity = Gravity.BOTTOM;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        imm = (InputMethodManager) mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
        mInput = (EditText) mRootView.findViewById(R.id.input);
        mInput.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEND) {
                    sendMessage();
                    return true;
                }
                return false;
            }
        });
        mInput.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 0) {
                    mMyRadioButton.doChecked(false);
                } else {
                    mMyRadioButton.doChecked(true);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        mInput.postDelayed(new Runnable() {
            @Override
            public void run() {
                //软键盘弹出
                imm.showSoftInput(mInput, InputMethodManager.SHOW_FORCED);
                mInput.requestFocus();
            }
        }, 200);
        mCheckBox = (CheckBox) mRootView.findViewById(R.id.danmu);
        mMyRadioButton = (MyRadioButton) mRootView.findViewById(R.id.btn_send);
        mMyRadioButton.setOnClickListener(this);
        Bundle bundle = getArguments();
        if (bundle == null) {
            return;
        }
        String danmuPrice = bundle.getString(Constants.LIVE_DANMU_PRICE);
        String coinName = bundle.getString(Constants.COIN_NAME);
        mHint1 = WordUtil.getString(R.string.live_open_alba) + danmuPrice + coinName + "/" + WordUtil.getString(R.string.live_tiao);
        mHint2 = WordUtil.getString(R.string.live_say_something);
        mCheckBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton button, boolean isChecked) {
                if (isChecked) {
                    mInput.setHint(mHint1);
                } else {
                    mInput.setHint(mHint2);
                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        sendMessage();
    }

    private void sendMessage() {
        String content = mInput.getText().toString().trim();
        if (!TextUtils.isEmpty(content)) {
            if (mCheckBox.isChecked()) {
                ((LiveActivity) mContext).sendDanmuMessage(content);
            } else {
                ((LiveActivity) mContext).sendChatMessage(content);
            }
            mInput.setText("");
        }
    }


    @Override
    public void onPause() {
        super.onPause();
        if (imm != null) {
            imm.hideSoftInputFromWindow(mInput.getWindowToken(), 0);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mContext=null;
    }
}
