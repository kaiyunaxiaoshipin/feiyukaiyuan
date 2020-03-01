package com.feiyu.beauty.adapter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.feiyu.beauty.bean.RockBean;
import com.feiyu.common.Constants;
import com.feiyu.beauty.R;

import java.util.ArrayList;
import java.util.List;

import cn.tillusory.sdk.bean.TiRockEnum;

/**
 * Created by cxf on 2018/8/3.
 */

public class RockAdapter extends RecyclerView.Adapter<RockAdapter.Vh> {

    private Context mContext;
    private List<RockBean> mList;
    private LayoutInflater mInflater;
    private ActionListener mActionListener;
    private int mCheckedPosition;
    private int mCheckedColor;
    private int mUnCheckedColor;
    private View.OnClickListener mOnClickListener;

    public RockAdapter(Context context) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
        mList = new ArrayList<>();
        TiRockEnum[] values = TiRockEnum.values();
        for (int i = 0, size = values.length; i < size; i++) {
            RockBean bean = new RockBean(values[i]);
            if (i == 0) {
                bean.setChecked(true);
            }
            mList.add(bean);
        }
        mCheckedColor = ContextCompat.getColor(context, R.color.global);
        mUnCheckedColor = 0xffffffff;
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null) {
                    int position = (int) tag;
                    if (mCheckedPosition != position) {
                        mList.get(mCheckedPosition).setChecked(false);
                        mList.get(position).setChecked(true);
                        notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                        notifyItemChanged(position, Constants.PAYLOAD);
                        mCheckedPosition = position;
                        if (mActionListener != null) {
                            mActionListener.onItemClick(mList.get(position).getTiRockEnum());
                        }
                    }
                }
            }
        };
    }

    public void setActionListener(ActionListener listener) {
        mActionListener = listener;
    }

    @Override
    public Vh onCreateViewHolder(ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.view_item_list_beauty_filter, parent, false));
    }

    @Override
    public void onBindViewHolder(Vh vh, int position) {

    }

    @Override
    public void onBindViewHolder(Vh vh, int position, List<Object> payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        vh.setData(mList.get(position), position, payload);
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {
        TextView mTextView;

        public Vh(View itemView) {
            super(itemView);
            mTextView = (TextView) itemView;
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(RockBean bean, int position, Object payload) {
            itemView.setTag(position);
            if (payload == null) {
                mTextView.setText(bean.getTiRockEnum().getString(mContext));
            }
            if (mCheckedPosition == position) {
                mTextView.setTextColor(mCheckedColor);
            } else {
                mTextView.setTextColor(mUnCheckedColor);
            }
        }
    }

    public interface ActionListener {
        void onItemClick(TiRockEnum tiRockEnum);
    }
}
