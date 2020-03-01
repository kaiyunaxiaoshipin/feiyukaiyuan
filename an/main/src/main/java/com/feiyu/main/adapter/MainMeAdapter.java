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
import com.feiyu.common.bean.UserItemBean;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.interfaces.OnItemClickListener;

import java.util.List;

/**
 * Created by cxf on 2018/9/28.
 */

public class MainMeAdapter extends RecyclerView.Adapter<MainMeAdapter.Vh> {

    private static final int NORMAL = 0;
    private static final int GROUP_LAST = 1;
    private static final int ALL_LAST = 2;

    private Context mContext;
    private List<UserItemBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;
    private OnItemClickListener<UserItemBean> mOnItemClickListener;

    public MainMeAdapter(Context context, List<UserItemBean> list) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null) {
                    UserItemBean bean = (UserItemBean) tag;
                    if (mOnItemClickListener != null) {
                        mOnItemClickListener.onItemClick(bean, 0);
                    }
                }
            }
        };
    }

    public void setOnItemClickListener(OnItemClickListener<UserItemBean> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    @Override
    public int getItemViewType(int position) {
        UserItemBean bean = mList.get(position);
        if (bean.isGroupLast()) {
            return GROUP_LAST;
        } else if (bean.isAllLast()) {
            return ALL_LAST;
        } else {
            return NORMAL;
        }
    }


    public void setList(List<UserItemBean> list) {
        if (list == null) {
            return;
        }
        boolean changed = false;
        if (mList.size() != list.size()) {
            changed = true;
        } else {
            for (int i = 0, size = mList.size(); i < size; i++) {
                if (!mList.get(i).equals(list.get(i))) {
                    changed = true;
                    break;
                }
            }
        }
        if (changed) {
            mList = list;
            notifyDataSetChanged();
        }
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        int res = 0;
        if (viewType == GROUP_LAST) {
            res = R.layout.item_main_me_1;
        } else if (viewType == ALL_LAST) {
            res = R.layout.item_main_me_2;
        } else {
            res = R.layout.item_main_me_0;
        }
        return new Vh(mInflater.inflate(res, parent, false));
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

        ImageView mThumb;
        TextView mName;

        public Vh(View itemView) {
            super(itemView);
            mThumb = (ImageView) itemView.findViewById(R.id.thumb);
            mName = (TextView) itemView.findViewById(R.id.name);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(UserItemBean bean) {
            itemView.setTag(bean);
            ImgLoader.display(mContext,bean.getThumb(), mThumb);
            mName.setText(bean.getName());
        }
    }
}
