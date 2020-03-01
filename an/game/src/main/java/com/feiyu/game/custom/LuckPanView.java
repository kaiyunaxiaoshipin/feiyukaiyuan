package com.feiyu.game.custom;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import com.feiyu.game.R;

import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.lang.ref.SoftReference;

/**
 * Created by cxf on 2017/10/21.
 */

public class LuckPanView extends View {

    private Paint mPaint;
    private BitmapFactory.Options mOptions;
    private int mR;
    private ImgHolder[] mHolders;
    private int mImgWidth;
    private int mImgHeight;
    private static final int COUNT = 20;
    private float mScale;
    private Rect mDst;

    public LuckPanView(Context context) {
        this(context, null);
    }

    public LuckPanView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public LuckPanView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mScale = context.getResources().getDisplayMetrics().density;
        init();
    }

    private void init() {
        mImgWidth = dp2px(40);
        mImgHeight = dp2px(45);
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mPaint.setDither(true);
        mOptions = new BitmapFactory.Options();
        mOptions.inPreferredConfig = Bitmap.Config.RGB_565;
        mOptions.inSampleSize = 1;
        mHolders = new ImgHolder[4];
        mHolders[0] = new ImgHolder(getBitmap(R.mipmap.icon_zp_1));
        mHolders[1] = new ImgHolder(getBitmap(R.mipmap.icon_zp_2));
        mHolders[2] = new ImgHolder(getBitmap(R.mipmap.icon_zp_3));
        mHolders[3] = new ImgHolder(getBitmap(R.mipmap.icon_zp_4));
    }


    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int widthSize = MeasureSpec.getSize(widthMeasureSpec);
        heightMeasureSpec = MeasureSpec.makeMeasureSpec(widthSize, MeasureSpec.EXACTLY);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        mR = w / 2;
        int y = (int) (mR * 0.6f);
        mDst = new Rect(-mImgWidth / 2, -y - mImgHeight, mImgWidth / 2, -y);
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        for (int i = 0; i < COUNT; i++) {
            canvas.save();
            canvas.translate(mR, mR); //将坐标中心平移到中心点
            int index = i % 4;
            canvas.rotate(i * 18, 0, 0);
            canvas.drawBitmap(mHolders[index].mBitmap, mHolders[index].mRect, mDst, mPaint);
            canvas.restore();
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

    private class ImgHolder {
        private Bitmap mBitmap;
        private Rect mRect;

        public ImgHolder(Bitmap bitmap) {
            mBitmap = bitmap;
            mRect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
        }
    }


    public void recycleBitmap() {
        if (mHolders != null) {
            for (ImgHolder h : mHolders) {
                if (h != null && h.mBitmap != null && !h.mBitmap.isRecycled()) {
                    h.mBitmap.recycle();
                }
            }
        }
    }

    private int dp2px(int dpVal) {
        return (int) (mScale * dpVal + 0.5f);
    }
}
