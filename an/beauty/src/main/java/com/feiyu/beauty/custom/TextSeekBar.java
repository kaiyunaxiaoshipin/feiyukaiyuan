package com.feiyu.beauty.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import com.feiyu.beauty.R;

/**
 * Created by cxf on 2018/6/22.
 */

public class TextSeekBar extends FrameLayout implements SeekBar.OnSeekBarChangeListener {

    private SeekBar mSeekBar;
    private TextView mTextView;
    private TextView mProgressVal;
    private Context mContext;
    private String mText;
    private int mProgress;
    private OnSeekChangeListener mOnSeekChangeListener;

    public TextSeekBar(Context context) {
        this(context, null);
    }

    public TextSeekBar(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public TextSeekBar(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;
        TypedArray ta = context.getResources().obtainAttributes(attrs, R.styleable.TextSeekBar);
        mText = ta.getString(R.styleable.TextSeekBar_text2);
        mProgress = ta.getInteger(R.styleable.TextSeekBar_progressVal, 0);
        ta.recycle();
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        View v = LayoutInflater.from(mContext).inflate(R.layout.view_seek_group, this, false);
        mSeekBar = (SeekBar) v.findViewById(R.id.seekBar);
        mTextView = (TextView) v.findViewById(R.id.text);
        mProgressVal = (TextView) v.findViewById(R.id.progressVal);
        mSeekBar.setProgress(mProgress);
        mSeekBar.setOnSeekBarChangeListener(this);
        mTextView.setText(mText);
        mProgressVal.setText(String.valueOf(mProgress));
        addView(v);
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        mProgress = progress;
        mProgressVal.setText(String.valueOf(progress));
        if (mOnSeekChangeListener != null) {
            mOnSeekChangeListener.onProgressChanged(TextSeekBar.this, progress);
        }
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
    }

    public int getProgress() {
        return mProgress;
    }

    public void setProgress(int progress) {
        mProgress = progress;
        if (mSeekBar != null) {
            mSeekBar.setProgress(progress);
        }
    }

    public float getFloatProgress() {
        return mProgress / 100f;
    }

    public void setOnSeekChangeListener(OnSeekChangeListener listener) {
        mOnSeekChangeListener = listener;
    }


    public interface OnSeekChangeListener {
        void onProgressChanged(View view, int progress);
    }

    @Override
    public void setEnabled(boolean enabled) {
        super.setEnabled(enabled);
        if (mSeekBar != null) {
            mSeekBar.setEnabled(enabled);
        }
        if (enabled) {
            setAlpha(1f);
        } else {
            setAlpha(0.5f);
        }
    }

}
