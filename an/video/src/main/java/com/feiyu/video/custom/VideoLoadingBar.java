package com.feiyu.video.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;

import com.feiyu.video.R;

/**
 * Created by cxf on 2018/6/30.
 */

public class VideoLoadingBar extends View {

    private int mWidth;
    private RectF mBgRectF;
    private Paint mBgPaint;
    private Paint mFgPaint;
    private RectF mFgRectF;
    private float mRate;
    private boolean mLoading;
    private int mBgColor;//背景色
    private int mFgColor;//前景色

    public VideoLoadingBar(Context context) {
        this(context, null);
    }

    public VideoLoadingBar(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public VideoLoadingBar(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.LoadingBar);
        mBgColor = ta.getColor(R.styleable.LoadingBar_lb_bg_color, 0xff000000);
        mFgColor = ta.getColor(R.styleable.LoadingBar_lb_fg_color, 0xffffffff);
        ta.recycle();
        initPaint();
    }

    private void initPaint() {
        mBgPaint = new Paint();
        mBgPaint.setAntiAlias(true);
        mBgPaint.setDither(true);
        mBgPaint.setColor(mBgColor);
        mBgPaint.setStyle(Paint.Style.FILL);
        mBgRectF = new RectF();

        mFgPaint = new Paint();
        mFgPaint.setAntiAlias(true);
        mFgPaint.setDither(true);
        mFgPaint.setColor(mFgColor);
        mFgPaint.setStyle(Paint.Style.FILL);
        mFgRectF = new RectF();
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
        mWidth = getMeasuredWidth();
        int height = getMeasuredHeight();
        mBgRectF.top = 0;
        mBgRectF.bottom = height;
        mFgRectF.top = 0;
        mFgRectF.bottom = height;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        mBgRectF.left = 0;
        mBgRectF.right = mWidth;
        canvas.drawRect(mBgRectF, mBgPaint);
        if (mLoading) {
            if (mRate > 1) {
                mRate = 1;
            }
            float barWidth = mRate * mWidth;
            float left = (mWidth - barWidth) / 2;
            mFgRectF.left = left;
            mFgRectF.right = left + barWidth;
            canvas.drawRect(mFgRectF, mFgPaint);
            if (mRate < 1) {
                mRate += 0.1f;
                postInvalidateDelayed(20);
            } else {
                mRate = 0;
                postInvalidateDelayed(150);
            }
        }
    }

    public void setLoading(boolean loading) {
        if (mLoading != loading) {
            mLoading = loading;
            mRate = 0;
            invalidate();
        }
    }

    public void endLoading() {
        mLoading = false;
        mRate = 0;
    }
}
