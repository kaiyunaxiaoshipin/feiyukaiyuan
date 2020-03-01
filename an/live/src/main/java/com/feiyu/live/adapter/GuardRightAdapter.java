package com.feiyu.live.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.live.R;
import com.feiyu.live.bean.GuardRightBean;
import com.feiyu.common.glide.ImgLoader;

import java.util.List;

/**
 * Created by cxf on 2018/11/6.
 */

public class GuardRightAdapter extends RecyclerView.Adapter<GuardRightAdapter.Vh> {

    private Context mContext;
    private List<GuardRightBean> mList;
    private LayoutInflater mInflater;
    private int mColor1;
    private int mColor2;

    public GuardRightAdapter(Context context, List<GuardRightBean> list) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mColor1 = ContextCompat.getColor(context, R.color.textColor);
        mColor2 = ContextCompat.getColor(context, R.color.gray3);
    }


    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int position) {
        return new Vh(mInflater.inflate(R.layout.guard_right, parent, false));
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

        ImageView mIcon;
        TextView mTitle;
        TextView mDes;

        public Vh(@NonNull View itemView) {
            super(itemView);
            mIcon = (ImageView) itemView.findViewById(R.id.icon);
            mTitle = (TextView) itemView.findViewById(R.id.title);
            mDes = (TextView) itemView.findViewById(R.id.des);
        }

        void setData(GuardRightBean bean) {
            ImgLoader.display(mContext,bean.getIconIndex() == 1 ? bean.getIcon1() : bean.getIcon0(), mIcon);
            mTitle.setText(bean.getTitle());
            mDes.setText(bean.getDes());
            if (bean.isChecked()) {
                mTitle.setTextColor(mColor1);
                mDes.setTextColor(mColor1);
            } else {
                mTitle.setTextColor(mColor2);
                mDes.setTextColor(mColor2);
            }
        }
    }
}
