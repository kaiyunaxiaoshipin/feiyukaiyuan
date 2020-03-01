package com.feiyu.video.custom;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.feiyu.video.R;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class ThumbnailAdapter extends RecyclerView.Adapter {

    private static final int TYPE_HEADER = 0;
    private static final int TYPE_NORMAL = 1;

    private Context mContext;
    private List<Bitmap> mList;
    private LayoutInflater mInflater;
    private int mScreenWdith;

    public ThumbnailAdapter(Context context) {
        mContext = context;
        mList = new ArrayList<>();
        DisplayMetrics dm = mContext.getResources().getDisplayMetrics();
        mScreenWdith = dm.widthPixels;
        mInflater = LayoutInflater.from(mContext);
    }

    public void addBitmapList(List<Bitmap> list){
        mList.addAll(list);
        notifyDataSetChanged();
    }

    public void reverse() {
        if (mList.size() > 0) {
            Collections.reverse(mList);
            notifyDataSetChanged();
        }
    }

    @Override
    public int getItemViewType(int position) {
        if (position == 0 || position == mList.size() + 1) {
            return TYPE_HEADER;
        } else {
            return TYPE_NORMAL;
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView;
        if (viewType == TYPE_HEADER) {
            itemView = new View(mContext);
            itemView.setLayoutParams(new ViewGroup.LayoutParams(mScreenWdith / 2, ViewGroup.LayoutParams.MATCH_PARENT));
            return new HeadVh(itemView);

        } else {
            return new Vh(mInflater.inflate(R.layout.item_video_progress_thumbnail, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder vh, int position) {
        if (vh instanceof Vh) {
            ((Vh) vh).setData(mList.get(position - 1));
        }
    }


    @Override
    public int getItemCount() {
        return mList.size() + 2;
    }


    @Override
    public void onViewRecycled(RecyclerView.ViewHolder vh) {
        if (vh != null && vh instanceof Vh) {
            ((Vh) vh).recycle();
        }
    }


    class HeadVh extends RecyclerView.ViewHolder {
        public HeadVh(View itemView) {
            super(itemView);
        }
    }

    class Vh extends RecyclerView.ViewHolder {

        ImageView img;

        public Vh(View itemView) {
            super(itemView);
            img = (ImageView) itemView;
        }

        void setData(Bitmap bitmap) {
            img.setImageBitmap(bitmap);
        }

        void recycle() {
            if (img != null) {
                img.setImageBitmap(null);
            }
        }
    }

}
