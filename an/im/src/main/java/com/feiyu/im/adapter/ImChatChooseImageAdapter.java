package com.feiyu.im.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.feiyu.common.Constants;
import com.feiyu.im.R;
import com.feiyu.im.bean.ChatChooseImageBean;
import com.feiyu.common.glide.ImgLoader;

import java.io.File;
import java.util.List;

/**
 * Created by cxf on 2018/6/20.
 * 聊天时候选择图片的Adapter
 */

public class ImChatChooseImageAdapter extends RecyclerView.Adapter<ImChatChooseImageAdapter.Vh> {

    private static final int POSITION_NONE = -1;
    private Context mContext;
    private List<ChatChooseImageBean> mList;
    private LayoutInflater mInflater;
    private int mSelectedPosition;

    public ImChatChooseImageAdapter(Context context, List<ChatChooseImageBean> list) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mSelectedPosition = POSITION_NONE;
    }

    @Override
    public Vh onCreateViewHolder(ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_chat_choose_img, parent, false));
    }

    @Override
    public void onBindViewHolder(Vh vh, int position) {

    }

    @Override
    public void onBindViewHolder(Vh vh, int position, List<Object> payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        vh.setData(mList.get(position), position, payload);
    }

    public File getSelectedFile() {
        if (mSelectedPosition != POSITION_NONE) {
            return mList.get(mSelectedPosition).getImageFile();
        }
        return null;
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {

        ImageView mCover;
        ImageView mImg;
        ChatChooseImageBean mBean;
        int mPosition;

        public Vh(View itemView) {
            super(itemView);
            mCover = (ImageView) itemView.findViewById(R.id.cover);
            mImg = (ImageView) itemView.findViewById(R.id.img);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mPosition == mSelectedPosition) {
                        return;
                    }
                    if (mSelectedPosition == POSITION_NONE) {
                        mBean.setChecked(true);
                        notifyItemChanged(mPosition, Constants.PAYLOAD);
                    } else {
                        mList.get(mSelectedPosition).setChecked(false);
                        mBean.setChecked(true);
                        notifyItemChanged(mSelectedPosition, Constants.PAYLOAD);
                        notifyItemChanged(mPosition, Constants.PAYLOAD);
                    }
                    mSelectedPosition = mPosition;
                }
            });
        }

        void setData(ChatChooseImageBean bean, int position, Object payload) {
            mBean = bean;
            mPosition = position;
            if (payload == null) {
                ImgLoader.display(mContext,bean.getImageFile(), mCover);
            }
            if (bean.isChecked()) {
                mImg.setImageResource(R.mipmap.icon_checked);
            } else {
                mImg.setImageResource(R.mipmap.icon_checked_none);
            }
        }
    }

}
