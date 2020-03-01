package com.feiyu.video.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;

import com.feiyu.video.R;

/**
 * Created by cxf on 2018/12/5.
 */

public class VideoRecordBtnView extends View {

    private static final int RATE_MAX = 100;
    private int mMaxWidth;
    private int mMinWidth;
    private int mStartWidth;
    private int mRate;
    private int mStrokeWidth;
    private Paint mPaint;
    private int mRadius;
    private Path mBgPath;
    private Path mFgPath;

    public VideoRecordBtnView(Context context) {
        this(context, null);
    }

    public VideoRecordBtnView(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public VideoRecordBtnView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.VideoRecordBtnView);
        mMaxWidth = (int) ta.getDimension(R.styleable.VideoRecordBtnView_vrb_max_width, 0);
        mMinWidth = (int) ta.getDimension(R.styleable.VideoRecordBtnView_vrb_min_width, 0);
        mStartWidth = (int) ta.getDimension(R.styleable.VideoRecordBtnView_vrb_start_width, 0);
        int color = ta.getColor(R.styleable.VideoRecordBtnView_vrb_color, 0);
        ta.recycle();
        mRate = RATE_MAX;
        mStrokeWidth = mStartWidth;
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mPaint.setDither(true);
        mPaint.setColor(color);
        mPaint.setStyle(Paint.Style.FILL);
        mBgPath = new Path();
        mFgPath = new Path();
    }


    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        mRadius = w / 2;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(widthSize, MeasureSpec.EXACTLY);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        mBgPath.reset();
        mBgPath.addCircle(mRadius, mRadius, mRadius, Path.Direction.CW);
        mFgPath.reset();
        mFgPath.addCircle(mRadius, mRadius, mRadius - mStrokeWidth, Path.Direction.CW);
        mBgPath.op(mFgPath, Path.Op.DIFFERENCE);
        canvas.drawPath(mBgPath, mPaint);
    }

    public void setRate(int rate) {
        if (rate < 0) {
            rate = 0;
        }
        if (rate > RATE_MAX) {
            rate = RATE_MAX;
        }
        if (mRate == rate) {
            return;
        }
        mRate = rate;
        int strokeWidth = calculateStrokeWidth();
        if (mStrokeWidth == strokeWidth) {
            return;
        }
        mStrokeWidth = strokeWidth;
        invalidate();
    }

    public void reset() {
        mStrokeWidth = mStartWidth;
        mRate = RATE_MAX;
        invalidate();
    }

    private int calculateStrokeWidth() {
        return (int) (mMinWidth + (mMaxWidth - mMinWidth) * mRate / 100f);
    }


}
