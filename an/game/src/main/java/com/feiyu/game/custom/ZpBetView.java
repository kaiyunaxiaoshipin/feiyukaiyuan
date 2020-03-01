package com.feiyu.game.custom;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.feiyu.game.R;

/**
 * Created by cxf on 2017/10/21.
 */

public class ZpBetView extends RelativeLayout {

    private int mSrc;
    private Context mContext;
    private TextView mTotalBet;
    private TextView mMyBet;
    private int mTotalBetVal;
    private int mMyBetVal;
    private String mWan;

    public ZpBetView(Context context) {
        super(context, null);
    }

    public ZpBetView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public ZpBetView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.ZpBetView);
        mSrc = ta.getResourceId(R.styleable.ZpBetView_zbv_src, 0);
        ta.recycle();
        mWan = context.getString(R.string.game_wan);
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        View view = LayoutInflater.from(mContext).inflate(R.layout.game_view_zp_bet, this, false);
        LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        params.addRule(RelativeLayout.CENTER_IN_PARENT);
        view.setLayoutParams(params);
        addView(view);
        ImageView img = (ImageView) view.findViewById(R.id.img);
        img.setImageResource(mSrc);
        mTotalBet = (TextView) view.findViewById(R.id.coin_total);
        mMyBet = (TextView) view.findViewById(R.id.coin_my);
    }

    public void updateBetVal(int betVal, boolean isSelf) {
        mTotalBetVal += betVal;
        showTotalBet();
        if (isSelf) {
            mMyBetVal += betVal;
            showSelfBet();
        }
    }

    public void setBetVal(int totalBet, int myBet) {
        mTotalBetVal = totalBet;
        mMyBetVal = myBet;
        if (mTotalBetVal > 0) {
            if (mTotalBet.getVisibility() != VISIBLE) {
                mTotalBet.setVisibility(VISIBLE);
            }
            showTotalBet();
        }
        if (mMyBetVal > 0) {
            if (mMyBet.getVisibility() != VISIBLE) {
                mMyBet.setVisibility(VISIBLE);
            }
            showSelfBet();
        }
    }

    /**
     * 显示下注总金额
     */
    private void showTotalBet() {
        String result;
        if (mTotalBetVal >= 10000) {
            if (mTotalBetVal % 10000 == 0) {
                result = String.valueOf(mTotalBetVal / 10000) + mWan;
            } else {
                result = String.format("%.1f",mTotalBetVal / 10000f) + mWan;
            }
        } else {
            result = String.valueOf(mTotalBetVal);
        }
        if(mTotalBet.getVisibility()==INVISIBLE){
            mTotalBet.setVisibility(VISIBLE);
        }
        mTotalBet.setText(result);
    }

    /**
     * 显示自己的下注总金额
     */
    private void showSelfBet() {
        String result;
        if (mMyBetVal >= 10000) {
            if (mMyBetVal % 10000 == 0) {
                result = String.valueOf(mMyBetVal / 10000) + mWan;
            } else {
                result = String.format("%.1f",mTotalBetVal / 10000f) + mWan;
            }
        } else {
            result = String.valueOf(mMyBetVal);
        }
        if(mMyBet.getVisibility()==INVISIBLE){
            mMyBet.setVisibility(VISIBLE);
        }
        mMyBet.setText(result);
    }

    public void reset() {
        mTotalBetVal = 0;
        mMyBetVal = 0;
        mTotalBet.setVisibility(INVISIBLE);
        mMyBet.setVisibility(INVISIBLE);
    }
}
