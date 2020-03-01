package com.feiyu.video.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.Constants;
import com.feiyu.video.R;
import com.feiyu.common.bean.ConfigBean;
import com.feiyu.common.mob.MobBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by cxf on 2018/10/19.
 * 视频发布分享
 */

public class VideoPubShareAdapter extends RecyclerView.Adapter<VideoPubShareAdapter.Vh> {

    private List<MobBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;
    private int mCheckedPosition;

    public VideoPubShareAdapter(Context context, ConfigBean configBean) {
        mList = new ArrayList<>();
        if (configBean != null) {
            List<MobBean> list = MobBean.getVideoShareTypeList(configBean.getVideoShareTypes());
            mList.addAll(list);
        }
        mInflater = LayoutInflater.from(context);
        mCheckedPosition = -1;
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                if (position == mCheckedPosition) {
                    mList.get(position).setChecked(false);
                    notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                    mCheckedPosition = -1;
                    return;
                }
                if (mCheckedPosition >= 0 && mCheckedPosition < mList.size()) {
                    mList.get(mCheckedPosition).setChecked(false);
                    notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                }
                MobBean bean = mList.get(position);
                bean.setChecked(true);
                notifyItemChanged(position, Constants.PAYLOAD);
                mCheckedPosition = position;
            }
        };
    }


    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_video_pub_share, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position) {

    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position, @NonNull List<Object> payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        vh.setData(mList.get(position), position, payload);
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {

        ImageView mIcon;
        TextView mName;

        public Vh(View itemView) {
            super(itemView);
            mIcon = (ImageView) itemView.findViewById(R.id.icon);
            mName = (TextView) itemView.findViewById(R.id.name);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(MobBean bean, int position, Object payload) {
            itemView.setTag(position);
            if (payload == null) {
                mName.setText(bean.getName());
            }
            mIcon.setImageResource(bean.isChecked() ? bean.getIcon1() : bean.getIcon2());
        }
    }

    public String getShareType() {
        if (mCheckedPosition >= 0 && mCheckedPosition < mList.size()) {
            return mList.get(mCheckedPosition).getType();
        }
        return null;
    }
}
