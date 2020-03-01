package com.feiyu.main.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.main.R;
import com.feiyu.common.bean.LiveClassBean;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.interfaces.OnItemClickListener;

import java.util.List;

/**
 * Created by cxf on 2018/9/25.
 */

public class MainHomeLiveClassAdapter extends RecyclerView.Adapter<MainHomeLiveClassAdapter.Vh> {

    private Context mContext;
    private List<LiveClassBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;
    private OnItemClickListener<LiveClassBean> mOnItemClickListener;
    private boolean mDialog;

    public MainHomeLiveClassAdapter(Context context, List<LiveClassBean> list, boolean dialog) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mDialog = dialog;
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null) {
                    int position = (int) tag;
                    LiveClassBean bean = mList.get(position);
                    if (mOnItemClickListener != null) {
                        mOnItemClickListener.onItemClick(bean, position);
                    }
                }
            }
        };
    }


    public void setOnItemClickListener(OnItemClickListener<LiveClassBean> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        int res = mDialog ? R.layout.item_main_home_live_class : R.layout.item_main_home_live_class_2;
        return new Vh(mInflater.inflate(res, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position) {
        vh.setData(mList.get(position), position);
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {
        ImageView mImg;
        TextView mName;

        public Vh(View itemView) {
            super(itemView);
            mImg = (ImageView) itemView.findViewById(R.id.img);
            mName = (TextView) itemView.findViewById(R.id.name);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(LiveClassBean bean, int position) {
            itemView.setTag(position);
            if (bean.isAll()) {
                mImg.setImageResource(R.mipmap.icon_main_class_all);
            } else {
                ImgLoader.display(mContext,bean.getThumb(), mImg);
            }
            mName.setText(bean.getName());
        }
    }
}
