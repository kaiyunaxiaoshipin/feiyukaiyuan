package com.feiyu.im.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.PagerSnapHelper;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.interfaces.CommonCallback;
import com.feiyu.common.utils.ClickUtil;
import com.feiyu.im.R;
import com.feiyu.im.bean.ImMessageBean;
import com.feiyu.im.custom.MyImageView;
import com.feiyu.im.utils.ImMessageUtil;

import java.io.File;
import java.util.List;

/**
 * Created by cxf on 2018/11/28.
 */

public class ChatImagePreviewAdapter extends RecyclerView.Adapter<ChatImagePreviewAdapter.Vh> {

    private Context mContext;
    private List<ImMessageBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;
    private ActionListener mActionListener;

    public ChatImagePreviewAdapter(Context context, List<ImMessageBean> list) {
        mContext = context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!ClickUtil.canClick()) {
                    return;
                }
                if (mActionListener != null) {
                    mActionListener.onImageClick();
                }
            }
        };
    }


    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_im_chat_img, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position) {
        vh.setData(mList.get(position));
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }


    @Override
    public void onAttachedToRecyclerView(@NonNull RecyclerView recyclerView) {
        PagerSnapHelper pagerSnapHelper = new PagerSnapHelper();
        pagerSnapHelper.attachToRecyclerView(recyclerView);
    }

    class Vh extends RecyclerView.ViewHolder {

        MyImageView mImg;
        CommonCallback<File> mCommonCallback;
        ImMessageBean mImMessageBean;

        public Vh(View itemView) {
            super(itemView);
            mImg = (MyImageView) itemView;
            mImg.setOnClickListener(mOnClickListener);
            mCommonCallback = new CommonCallback<File>() {
                @Override
                public void callback(File file) {
                    if (mImMessageBean != null && mImg != null) {
                        mImMessageBean.setImageFile(file);
                        mImg.setFile(file);
                        ImgLoader.display(mContext, file, mImg);
                    }
                }
            };
        }

        void setData(ImMessageBean bean) {
            mImMessageBean = bean;
            File imageFile = bean.getImageFile();
            if (imageFile != null) {
                mImg.setFile(imageFile);
                ImgLoader.display(mContext, imageFile, mImg);
            } else {
                ImMessageUtil.getInstance().displayImageFile(mContext, bean, mCommonCallback);
            }
        }
    }

    public void setActionListener(ActionListener actionListener) {
        mActionListener = actionListener;
    }

    public interface ActionListener {
        void onImageClick();
    }
}
