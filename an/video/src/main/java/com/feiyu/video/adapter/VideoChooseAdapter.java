package com.feiyu.video.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.video.R;
import com.feiyu.video.bean.VideoChooseBean;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.interfaces.OnItemClickListener;

import java.util.List;

/**
 * Created by cxf on 2018/6/20.
 */

public class VideoChooseAdapter extends RecyclerView.Adapter<VideoChooseAdapter.Vh> {

    private Context mContext;
    private List<VideoChooseBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;
    private OnItemClickListener<VideoChooseBean> mOnItemClickListener;

    public VideoChooseAdapter(Context context, List<VideoChooseBean> list) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick((VideoChooseBean) tag, 0);
                }
            }
        };
    }

    public void setOnItemClickListener(OnItemClickListener<VideoChooseBean> listener) {
        mOnItemClickListener = listener;
    }


    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_video_choose_local, parent, false));
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

        ImageView mCover;
        TextView mDuration;

        public Vh(View itemView) {
            super(itemView);
            mCover = (ImageView) itemView.findViewById(R.id.cover);
            mDuration = (TextView) itemView.findViewById(R.id.duration);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(VideoChooseBean bean) {
            itemView.setTag(bean);
            ImgLoader.displayVideoThumb(mContext,bean.getVideoPath(), mCover);
            mDuration.setText(bean.getDurationString());
        }
    }

}
