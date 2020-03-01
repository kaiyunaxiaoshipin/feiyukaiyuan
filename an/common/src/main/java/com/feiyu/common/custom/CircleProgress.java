package com.feiyu.common.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;

import com.feiyu.common.R;

/**
 * Created by cxf on 2019/4/27.
 */

public class CircleProgress extends View {

    private float mStrokeWidth;
    private float mR;
    private int mBgColor;
    private int mFgColor;
    private float mMaxProgress;
    private float mCurProgress;
    private Paint mBgPaint;
    private Paint mFgPaint;
    private float mX;
    private RectF mRectF;

    public CircleProgress(Context context) {
        this(context, null);
    }

    public CircleProgress(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CircleProgress(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.CircleProgress);
        mBgColor = ta.getColor(R.styleable.CircleProgress_cp_bg_color, 0);
        mFgColor = ta.getColor(R.styleable.CircleProgress_cp_fg_color, 0);
        mStrokeWidth = ta.getDimension(R.styleable.CircleProgress_cp_stroke_width, 0);
        mMaxProgress = ta.getFloat(R.styleable.CircleProgress_cp_max_progress, 0);
        mCurProgress = ta.getFloat(R.styleable.CircleProgress_cp_cur_progress, 0);
        ta.recycle();
        initPaint();
    }

    private void initPaint() {
        mBgPaint = new Paint();
        mBgPaint.setAntiAlias(true);
        mBgPaint.setDither(true);
        mBgPaint.setColor(mBgColor);
        mBgPaint.setStyle(Paint.Style.STROKE);
        mBgPaint.setStrokeWidth(mStrokeWidth);

        mFgPaint = new Paint();
        mFgPaint.setAntiAlias(true);
        mFgPaint.setDither(true);
        mFgPaint.setColor(mFgColor);
        mFgPaint.setStyle(Paint.Style.STROKE);
        mFgPaint.setStrokeWidth(mStrokeWidth);
        mRectF = new RectF();
    }


    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
        super.onMeasure(widthMeasureSpec, MeasureSpec.makeMeasureSpec(widthSize, MeasureSpec.EXACTLY));
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        float offset = mStrokeWidth / 2;
        mX = w / 2;
        mR = mX - offset;
        mRectF = new RectF();
        mRectF.left = offset;
        mRectF.top = offset;
        mRectF.right = w - offset;
        mRectF.bottom = mRectF.right;

    }

    @Override
    protected void onDraw(Canvas canvas) {
        canvas.drawCircle(mX, mX, mR, mBgPaint);
        if (mMaxProgress > 0 && mCurProgress > 0) {
            canvas.drawArc(mRectF, -90, mCurProgress / mMaxProgress * 360, false, mFgPaint);
        }
    }

    public void setMaxProgress(float maxProgress) {
        mMaxProgress = maxProgress;
    }

    public void setCurProgress(float curProgress) {
        mCurProgress = curProgress;
        invalidate();
    }
}
