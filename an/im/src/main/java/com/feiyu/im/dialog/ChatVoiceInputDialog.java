package com.feiyu.im.dialog;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.TextView;

import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.im.R;
import com.feiyu.baidu.utils.ImAsrUtil;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.im.views.ChatRoomViewHolder;

/**
 * Created by cxf on 2018/11/12.
 * 聊天语音输入
 */

public class ChatVoiceInputDialog extends AbsDialogFragment implements View.OnClickListener {

    private View mBtnBg;
    private ScaleAnimation mAnimation;
    private View mBtnInput;
    private View mTip;
    private View mBtnClose;
    private View mSendGroup;
    private TextView mContent;
    private ImAsrUtil mImAsrUtil;//语音识别
    private String mPleaseSayString;
    private ChatRoomViewHolder mChatRoomViewHolder;

    @Override
    protected int getLayoutId() {
        return R.layout.chat_voice_input;
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
        params.height = DpUtil.dp2px(200);
        params.gravity = Gravity.BOTTOM;
        window.setAttributes(params);
    }

    public void setChatRoomViewHolder(ChatRoomViewHolder chatRoomViewHolder) {
        mChatRoomViewHolder = chatRoomViewHolder;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mBtnBg = mRootView.findViewById(R.id.btn_bg);
        mAnimation = new ScaleAnimation(1, 1.5f, 1, 1.5f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mAnimation.setDuration(700);
        mAnimation.setRepeatCount(-1);
        mBtnInput = mRootView.findViewById(R.id.btn_input);
        mBtnInput.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent e) {
                switch (e.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        startInput();
                        break;
                    case MotionEvent.ACTION_UP:
                        stopInput();
                        break;
                }
                return true;
            }
        });
        mTip = mRootView.findViewById(R.id.tip);
        mSendGroup = mRootView.findViewById(R.id.group2);
        mContent = mRootView.findViewById(R.id.content);
        mBtnClose = mRootView.findViewById(R.id.btn_close);
        mBtnClose.setOnClickListener(this);
        mRootView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        mRootView.findViewById(R.id.btn_send).setOnClickListener(this);
        mImAsrUtil = new ImAsrUtil(mContext);
        mImAsrUtil.setAsrCallback(new ImAsrUtil.AsrCallback() {
            @Override
            public void onResult(String result) {
                if (!TextUtils.isEmpty(result) && mContent != null) {
                    mContent.setText(result);
                }
            }
        });
        mPleaseSayString = WordUtil.getString(R.string.im_please_say);
    }

    /**
     * 开始输入
     */
    private void startInput() {
        if (mBtnBg != null && mAnimation != null) {
            mBtnBg.startAnimation(mAnimation);
        }
        mContent.setText(mPleaseSayString);
        if (mTip != null && mTip.getVisibility() == View.VISIBLE) {
            mTip.setVisibility(View.INVISIBLE);
        }
        if (mBtnClose != null && mBtnClose.getVisibility() == View.VISIBLE) {
            mBtnClose.setVisibility(View.INVISIBLE);
        }
        if (mImAsrUtil != null) {
            mImAsrUtil.start();
        }
    }

    /**
     * 结束输入
     */
    private void stopInput() {
        if (mBtnBg != null) {
            mBtnBg.clearAnimation();
        }
        if (mImAsrUtil != null) {
            mImAsrUtil.stop();
        }
        String content = mContent.getText().toString().trim();
        if (mPleaseSayString.equals(content)) {
            cancel();
        } else {
            if (mSendGroup.getVisibility() != View.VISIBLE) {
                mSendGroup.setVisibility(View.VISIBLE);
            }
        }
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.btn_close) {
            dismiss();

        } else if (i == R.id.btn_cancel) {
            cancel();

        } else if (i == R.id.btn_send) {
            send();

        }
    }

    private void cancel() {
        mContent.setText("");
        if (mSendGroup.getVisibility() == View.VISIBLE) {
            mSendGroup.setVisibility(View.INVISIBLE);
        }
        if (mBtnClose.getVisibility() != View.VISIBLE) {
            mBtnClose.setVisibility(View.VISIBLE);
        }
        if (mTip.getVisibility() != View.VISIBLE) {
            mTip.setVisibility(View.VISIBLE);
        }
    }

    private void send() {
        if (mChatRoomViewHolder != null) {
            String content = mContent.getText().toString().trim();
            mChatRoomViewHolder.sendText(content);
        }
        dismiss();
    }

    @Override
    public void onDestroy() {
        mChatRoomViewHolder = null;
        if (mImAsrUtil != null) {
            mImAsrUtil.release();
        }
        mImAsrUtil = null;
        super.onDestroy();
    }
}
