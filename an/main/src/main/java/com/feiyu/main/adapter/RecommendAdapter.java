package com.feiyu.main.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.Constants;
import com.feiyu.common.custom.MyRadioButton;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.main.R;
import com.feiyu.main.bean.RecommendBean;

import java.util.List;

/**
 * Created by cxf on 2017/10/23.
 */

public class RecommendAdapter extends RecyclerView.Adapter<RecommendAdapter.Vh> {

    private Context mContext;
    private List<RecommendBean> mList;
    private LayoutInflater mInflater;
    private View.OnClickListener mOnClickListener;

    public RecommendAdapter(Context context, List<RecommendBean> list) {
        mList = list;
        mInflater = LayoutInflater.from(context);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null) {
                    int position = (int) tag;
                    RecommendBean bean = mList.get(position);
                    bean.toggleChecked();
                    notifyItemChanged(position, Constants.PAYLOAD);
                }
            }
        };
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_recommend, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Vh holder, int position) {

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

        ImageView mAvatar;
        MyRadioButton mRadioButton;
        TextView mName;
        TextView mFans;

        public Vh(View itemView) {
            super(itemView);
            mAvatar = itemView.findViewById(R.id.avatar);
            mRadioButton = itemView.findViewById(R.id.radioButton);
            mName = itemView.findViewById(R.id.name);
            mFans = itemView.findViewById(R.id.fans);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(RecommendBean bean, int position, Object payload) {
            itemView.setTag(position);
            if (payload == null) {
                ImgLoader.displayAvatar(mContext,bean.getAvatar(), mAvatar);
                mName.setText(bean.getUserNiceName());
                mFans.setText(bean.getFans());
            }
            mRadioButton.doChecked(bean.isChecked());
        }
    }

    public String getCheckedUid() {
        String result = "";
        if (mList == null || mList.size() == 0) {
            return result;
        }
        for (RecommendBean bean : mList) {
            if (bean.isChecked()) {
                result += bean.getId() + ",";
            }
        }
        if (result.length() > 0) {
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }
}
