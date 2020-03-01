package com.feiyu.live.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;

import com.feiyu.live.R;

/**
 * Created by cxf on 2018/11/17.
 */

public class PkProgressBar extends View {

    private Paint mPaint1;
    private Paint mPaint2;
    private int mMinWidth;
    private float mRate;
    private int mLeftColor;
    private int mRightColor;
    private Rect mRect1;
    private Rect mRect2;
    private int mWidth;

    public PkProgressBar(Context context) {
        this(context, null);
    }

    public PkProgressBar(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public PkProgressBar(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.PkProgressBar);
        mMinWidth = (int) ta.getDimension(R.styleable.PkProgressBar_ppb_minWidth, 0);
        mRate = ta.getFloat(R.styleable.PkProgressBar_ppb_rate, 0.5f);
        mLeftColor = ta.getColor(R.styleable.PkProgressBar_ppb_left_color, 0);
        mRightColor = ta.getColor(R.styleable.PkProgressBar_ppb_right_color, 0);
        ta.recycle();
        init();
    }

    private void init() {
        mPaint1 = new Paint();
        mPaint1.setAntiAlias(true);
        mPaint1.setDither(true);
        mPaint1.setStyle(Paint.Style.FILL);
        mPaint1.setColor(mLeftColor);
        mPaint2 = new Paint();
        mPaint2.setAntiAlias(true);
        mPaint2.setDither(true);
        mPaint2.setStyle(Paint.Style.FILL);
        mPaint2.setColor(mRightColor);
        mRect1 = new Rect();
        mRect2 = new Rect();
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        mWidth = w;
        mRect1.left = 0;
        mRect1.top = 0;
        mRect1.bottom = h;
        mRect2.top = 0;
        mRect2.right = w;
        mRect2.bottom = h;
        changeProgress();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        canvas.drawRect(mRect1, mPaint1);
        canvas.drawRect(mRect2, mPaint2);
    }

    public void setProgress(float rate) {
        if (mRate == rate) {
            return;
        }
        mRate = rate;
        changeProgress();
        invalidate();
    }

    private void changeProgress() {
        int bound = (int) (mWidth * mRate);
        if (bound < mMinWidth) {
            bound = mMinWidth;
        }
        if (bound > mWidth - mMinWidth) {
            bound = mWidth - mMinWidth;
        }
        mRect1.right = bound;
        mRect2.left = bound;
    }


}
