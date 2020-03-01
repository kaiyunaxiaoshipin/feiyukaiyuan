package com.feiyu.beauty.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.RadioButton;

import com.feiyu.beauty.R;


/**
 * Created by cxf on 2017/7/19.
 * 可以调节drawable大小的RadioButton
 */

public class MyRadioButton extends RadioButton {

    private int mDrawableSize;
    private int mTopDrawableSize;
    private int mLeftDrawableSize;
    private int mRightDrawableSize;
    private int mBottomDrawableSize;
    private Drawable mTopDrawable;
    private Drawable mLeftDrawable;
    private Drawable mRightDrawable;
    private Drawable mBottomDrawable;
    private float mScale;

    public MyRadioButton(Context context) {
        this(context, null);
    }

    public MyRadioButton(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MyRadioButton(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mScale = context.getResources().getDisplayMetrics().density;
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.MyRadioButton);
        mDrawableSize = (int) ta.getDimension(R.styleable.MyRadioButton_mr_drawableSize1, dp2px(20));
        mTopDrawableSize = (int) ta.getDimension(R.styleable.MyRadioButton_mr_top_drawableSize1, mDrawableSize);
        mLeftDrawableSize = (int) ta.getDimension(R.styleable.MyRadioButton_mr_left_drawableSize1, mDrawableSize);
        mRightDrawableSize = (int) ta.getDimension(R.styleable.MyRadioButton_mr_right_drawableSize1, mDrawableSize);
        mBottomDrawableSize = (int) ta.getDimension(R.styleable.MyRadioButton_mr_bottom_drawableSize1, mDrawableSize);
        mTopDrawable = ta.getDrawable(R.styleable.MyRadioButton_mr_top_drawable1);
        mLeftDrawable = ta.getDrawable(R.styleable.MyRadioButton_mr_left_drawable1);
        mRightDrawable = ta.getDrawable(R.styleable.MyRadioButton_mr_right_drawable1);
        mBottomDrawable = ta.getDrawable(R.styleable.MyRadioButton_mr_bottom_drawable1);
        ta.recycle();

    }

    public void setTopDrawable(Drawable topDrawable) {
        mTopDrawable = topDrawable;
    }

    public void setBottomDrawable(Drawable bottomDrawable) {
        mBottomDrawable = bottomDrawable;
    }

    public void setLeftDrawable(Drawable leftDrawable) {
        mLeftDrawable = leftDrawable;
    }

    public void setRightDrawable(Drawable rightDrawable) {
        mRightDrawable = rightDrawable;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        setCompoundDrawablesWithIntrinsicBounds(mLeftDrawable, mTopDrawable, mRightDrawable, mBottomDrawable);
    }

    @Override
    public void setCompoundDrawablesWithIntrinsicBounds(Drawable left, Drawable top, Drawable right, Drawable bottom) {
        if (left != null) {
            left.setBounds(0, 0, mLeftDrawableSize, mLeftDrawableSize);
        }
        if (top != null) {
            top.setBounds(0, 0, mTopDrawableSize, mTopDrawableSize);
        }
        if (right != null) {
            right.setBounds(0, 0, mRightDrawableSize, mRightDrawableSize);
        }
        if (bottom != null) {
            bottom.setBounds(0, 0, mBottomDrawableSize, mBottomDrawableSize);
        }
        setCompoundDrawables(left, top, right, bottom);
    }


    private int dp2px(int dpVal) {
        return (int) (dpVal * mScale + 0.5f);
    }

}
