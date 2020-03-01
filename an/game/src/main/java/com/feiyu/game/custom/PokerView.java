package com.feiyu.game.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Interpolator;

import com.feiyu.game.R;

import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.lang.ref.SoftReference;

/**
 * Created by cxf on 2017/10/7.
 */

public class PokerView extends View {

    private Paint mBgPaint;
    private Paint mPaint;
    private BitmapFactory.Options mOptions;
    private int mWidth;
    private int mHeight;
    private float mScale;
    private int mR;
    private int mTriangleWidth;
    private int mTriangleHeight;
    private int mTriangleDirection;//箭头方向
    private Rect[] mRects;
    private Bitmap[] mBitmaps;
    private Rect mSrc;
    private Bitmap mCoverBitmap;
    private int mCoverSrc;
    private int mCount;//扑克牌的数量
    private static final int READY = 0;
    private static final int SEND_CARD = 1;
    private static final int SHOW = 2;
    private int mStatus = READY;
    public static final int SEND_DURATION = 200;//发牌过程持续时间
    private static final int MAX_FREAMS = 10;//发牌动画的帧数
    private int mCurFrame = 0;//当前帧数
    private int mPokerWidth;//每张牌的宽度
    private Rect mPokerArea;//展示牌的区域
    private int mPokerAreaWidth;//全部放牌区域的宽度
    private int mCurPokerAreaWidth;//当前放牌区域的宽度
    private static final int ARROW_LEFT = 0;
    private static final int ARROW_RIGHT = 1;
    private float mRate;//牌面遮盖的范围相对牌宽度的百分比,默认为0.1f
    private boolean mHasTriangle;//是否带有三角形
    private boolean mEnd;
    private Interpolator mInterpolator;

    public PokerView(Context context) {
        this(context, null);
    }

    public PokerView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public PokerView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mScale = context.getResources().getDisplayMetrics().density;
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.PokerView);
        mCoverSrc = ta.getResourceId(R.styleable.PokerView_pv_coverSrc, 0);
        mCount = ta.getInteger(R.styleable.PokerView_pv_count, 3);
        mRate = ta.getFloat(R.styleable.PokerView_pv_rate, 0.1f);
        mTriangleDirection = ta.getInt(R.styleable.PokerView_pv_arrow, ARROW_LEFT);
        mHasTriangle = ta.getBoolean(R.styleable.PokerView_pv_hasTriangle, true);
        ta.recycle();
        init();
    }

    private void init() {
        mBgPaint = new Paint();
        mBgPaint.setAntiAlias(true);
        mBgPaint.setDither(true);
        mBgPaint.setColor(0x80333333);
        mBgPaint.setStyle(Paint.Style.FILL);
        mBgPaint.setStrokeWidth(dp2px(1));
        mPaint = new Paint();
        mBgPaint.setAntiAlias(true);
        mBgPaint.setDither(true);
        mOptions = new BitmapFactory.Options();
        mOptions.inPreferredConfig = Bitmap.Config.RGB_565;
        mOptions.inSampleSize = 1;
        mR = dp2px(5);
        mTriangleWidth = dp2px(10);
        mTriangleHeight = dp2px(10);
        mBitmaps = new Bitmap[mCount];
        mRects = new Rect[mCount];
        for (int i = 0; i < mCount; i++) {
            mRects[i] = new Rect();
        }
        mPokerArea = new Rect();
        if (mCoverSrc != 0) {
            mCoverBitmap = getBitmap(mCoverSrc);
            mSrc = new Rect();
            mSrc.left = 0;
            mSrc.top = 0;
            mSrc.right = mCoverBitmap.getWidth();
            mSrc.bottom = mCoverBitmap.getHeight();
        }
        mInterpolator = new AccelerateDecelerateInterpolator();
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
        if (mWidth == 0) {
            mWidth = getMeasuredWidth();
            mHeight = getMeasuredHeight();
            mPokerAreaWidth = (mWidth - mR * 2);
            mPokerArea.top = mR;
            if (mHasTriangle) {
                mPokerArea.bottom = mHeight - mTriangleHeight - mR;
            } else {
                mPokerArea.bottom = mHeight - mR;
            }
            mPokerWidth = (int) (mPokerAreaWidth / mCount * (1 + mRate));//扑克牌的宽度
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (mEnd) {
            return;
        }
        drawBg(canvas);
        switch (mStatus) {
            case SEND_CARD:
                setPokerAreaWidth();
                calculateEveryPosition();
                for (int i = 0; i < mCount; i++) {
                    if (mEnd) {
                        return;
                    }
                    canvas.drawBitmap(mCoverBitmap, mSrc, mRects[i], mPaint);
                }
                if (mCurFrame < MAX_FREAMS) {
                    mCurFrame++;
                    postInvalidateDelayed(SEND_DURATION / MAX_FREAMS);
                }
                break;
            case SHOW:
                for (int i = 0; i < mCount; i++) {
                    if (mEnd) {
                        return;
                    }
                    mSrc.left = 0;
                    mSrc.top = 0;
                    mSrc.right = mBitmaps[i].getWidth();
                    mSrc.bottom = mBitmaps[i].getHeight();
                    canvas.drawBitmap(mBitmaps[i], mSrc, mRects[i], mPaint);
                }
                break;
        }
    }

    private void drawBg(Canvas canvas) {
        if (mHasTriangle) {
            canvas.drawRoundRect(new RectF(0, 0, mWidth, mHeight - mTriangleHeight), mR, mR, mBgPaint);
            Path path = new Path();
            if (mTriangleDirection == ARROW_LEFT) {
                path.moveTo(mWidth * 0.2f, mHeight - mTriangleHeight);
                path.rLineTo(0, mTriangleHeight);
                path.rLineTo(mTriangleWidth, -mTriangleHeight);
                path.close();
            } else {
                path.moveTo(mWidth * 0.8f, mHeight - mTriangleHeight);
                path.rLineTo(0, mTriangleHeight);
                path.rLineTo(-mTriangleWidth, -mTriangleHeight);
                path.close();
            }
            canvas.drawPath(path, mBgPaint);
        } else {
            canvas.drawRoundRect(new RectF(0, 0, mWidth, mHeight), mR, mR, mBgPaint);
        }
    }

    /**
     * 计算放牌区域的宽度
     */
    private void setPokerAreaWidth() {
        mCurPokerAreaWidth = (int) (mPokerWidth + (mPokerAreaWidth - mPokerWidth) * mInterpolator.getInterpolation((float) mCurFrame / MAX_FREAMS));
        mPokerArea.left = mR;
        mPokerArea.right = mPokerArea.left + mCurPokerAreaWidth;
    }


    /**
     * 计算每一张牌的位置
     */
    private void calculateEveryPosition() {
        //扑克宽度减去重叠区域的宽度剩余的量
        int lastWidth = mPokerWidth - (mPokerWidth * mCount - mCurPokerAreaWidth) / (mCount - 1);
        for (int i = 0; i < mCount; i++) {
            mRects[i].left = lastWidth * i + mPokerArea.left;
            mRects[i].right = mRects[i].left + mPokerWidth;
            mRects[i].top = mPokerArea.top;
            mRects[i].bottom = mPokerArea.bottom;
        }
    }

    private Bitmap getBitmap(int resId) {
        Bitmap bitmap = null;
        try {
            byte[] bytes = IOUtils.toByteArray(getResources().openRawResource(resId));
            bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length, mOptions);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new SoftReference<>(bitmap).get();
    }


    public void sendCard() {
        mStatus = SEND_CARD;
        mCurFrame = 0;
        invalidate();
    }

    public void clearCard() {
        mStatus = READY;
        invalidate();
    }

    /**
     * 显示牌面结果
     */
    public void showResult(int... resIds) {
        mStatus = SHOW;
        for (int i = 0; i < mBitmaps.length; i++) {
            if (mBitmaps[i] != null) {
                mBitmaps[i].recycle();
            }
            mBitmaps[i] = getBitmap(resIds[i]);
        }
        invalidate();
    }

    public void recycleBitmap() {
        mEnd = true;
        for (int i = 0, length = mBitmaps.length; i < length; i++) {
            if (mBitmaps[i] != null && !mBitmaps[i].isRecycled()) {
                mBitmaps[i].recycle();
            }
        }
    }

    private int dp2px(int dpVal) {
        return (int) (mScale * dpVal + 0.5f);
    }

}
