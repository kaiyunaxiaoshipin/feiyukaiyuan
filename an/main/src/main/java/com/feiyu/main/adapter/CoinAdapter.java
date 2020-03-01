package com.feiyu.main.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.feiyu.common.bean.CoinBean;
import com.feiyu.common.interfaces.OnItemClickListener;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.main.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by cxf on 2018/10/23.
 */

public class CoinAdapter extends RecyclerView.Adapter<CoinAdapter.Vh> {

    private String mCoinName;
    private List<CoinBean> mList;
    private String mGiveString;
    private LayoutInflater mInflater;
    private int mHeadHeight;
    private int mScrollY;
    private View mContactView;
    private View.OnClickListener mOnClickListener;
    private OnItemClickListener<CoinBean> mOnItemClickListener;

    public CoinAdapter(Context context, String coinName) {
        mHeadHeight = DpUtil.dp2px(150);
        mCoinName = coinName;
        mList = new ArrayList<>();
        mInflater = LayoutInflater.from(context);
        mGiveString = WordUtil.getString(R.string.coin_give);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick((CoinBean) tag, 0);
                }
            }
        };
    }

    public void setList(List<CoinBean> list) {
        if (list != null && list.size() > 0) {
            mList.clear();
            mList.addAll(list);
            notifyDataSetChanged();
        }
    }

    public void setOnItemClickListener(OnItemClickListener<CoinBean> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_coin, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position) {
        vh.setData(mList.get(position));
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {

        TextView mCoin;
        TextView mMoney;
        TextView mGive;

        public Vh(View itemView) {
            super(itemView);
            mCoin = itemView.findViewById(R.id.coin);
            mMoney = itemView.findViewById(R.id.money);
            mGive = itemView.findViewById(R.id.give);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(CoinBean bean) {
            itemView.setTag(bean);
            mCoin.setText(bean.getCoin());
            mMoney.setText("￥" + bean.getMoney());
            if (!"0".equals(bean.getGive())) {
                if (mGive.getVisibility() != View.VISIBLE) {
                    mGive.setVisibility(View.VISIBLE);
                }
                mGive.setText(mGiveString + bean.getGive() + mCoinName);
            } else {
                if (mGive.getVisibility() == View.VISIBLE) {
                    mGive.setVisibility(View.INVISIBLE);
                }
            }
        }
    }


    @Override
    public void onAttachedToRecyclerView(@NonNull RecyclerView recyclerView) {
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {

            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                mScrollY += dy;
                if (mContactView != null) {
                    int targetScrollY = -mScrollY;
                    if (targetScrollY < -mHeadHeight) {
                        targetScrollY = -mHeadHeight;
                    }
                    if (targetScrollY > 0) {
                        targetScrollY = 0;
                    }
                    if (mContactView.getTranslationY() != targetScrollY) {
                        mContactView.setTranslationY(targetScrollY);
                    }
                }
            }
        });
    }

    public void setContactView(View contactView) {
        mContactView = contactView;
    }
}
