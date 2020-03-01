package com.feiyu.video.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.Constants;
import com.feiyu.video.R;
import com.feiyu.video.bean.VideoReportBean;

import java.util.List;

/**
 * Created by cxf on 2018/12/15.
 */

public class VideoReportAdapter extends RecyclerView.Adapter {

    private static final int HEAD = -1;
    private static final int FOOT = -2;
    private static final int NORMAL = 0;
    private static final int NORMAL_LAST = 1;

    private List<VideoReportBean> mList;
    private LayoutInflater mInflater;
    private Drawable mCheckedDrawable;
    private Drawable mUnCheckedDrawable;
    private int mCheckedPosition;
    private View.OnClickListener mOnClickListener;
    private View.OnClickListener mReportListener;
    private FootVh mFootVh;
    private ActionListener mActionListener;
    private VideoReportBean mCurVideoReportBean;

    public VideoReportAdapter(Context context, List<VideoReportBean> list) {
        mList = list;
        mInflater = LayoutInflater.from(context);
        mCheckedDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_cash_radio_1);
        mUnCheckedDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_cash_radio_0);
        mCheckedPosition = -1;
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                VideoReportBean bean = mList.get(position - 1);
                if (mCheckedPosition == position) {
                    bean.setChecked(false);
                    notifyItemChanged(position, Constants.PAYLOAD);
                    mCheckedPosition = -1;
                    mCurVideoReportBean = null;
                } else {
                    if (mCheckedPosition >= 0) {
                        mList.get(mCheckedPosition - 1).setChecked(false);
                        notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                    }
                    bean.setChecked(true);
                    notifyItemChanged(position, Constants.PAYLOAD);
                    mCheckedPosition = position;
                    mCurVideoReportBean = bean;
                }
            }
        };
        mReportListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mFootVh != null) {
                    mFootVh.submit();
                }
            }
        };
    }

    @Override
    public int getItemViewType(int position) {
        if (position == 0) {
            return HEAD;
        } else if (position == mList.size() + 1) {
            return FOOT;
        } else {
            if (position == mList.size()) {
                return NORMAL_LAST;
            }
            return NORMAL;
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == HEAD) {
            return new HeadVh(mInflater.inflate(R.layout.item_video_report_head, parent, false));
        } else if (viewType == FOOT) {
            if (mFootVh == null) {
                mFootVh = new FootVh(mInflater.inflate(R.layout.item_video_report_foot, parent, false));
            }
            return mFootVh;
        } else {
            if (viewType == NORMAL_LAST) {
                return new Vh(mInflater.inflate(R.layout.item_video_report_2, parent, false));
            }
            return new Vh(mInflater.inflate(R.layout.item_video_report, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder vh, int position) {

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder vh, int position, @NonNull List payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        if (vh instanceof Vh) {
            ((Vh) vh).setData(mList.get(position - 1), position, payload);
        }
    }

    @Override
    public int getItemCount() {
        return mList.size() + 2;
    }

    class HeadVh extends RecyclerView.ViewHolder {

        public HeadVh(View itemView) {
            super(itemView);
        }
    }

    class FootVh extends RecyclerView.ViewHolder {

        EditText mEditText;

        public FootVh(View itemView) {
            super(itemView);
            mEditText = itemView.findViewById(R.id.edit);
            itemView.findViewById(R.id.btn_report).setOnClickListener(mReportListener);
        }

        void submit() {
            String text = mEditText.getText().toString().trim();
            if (mActionListener != null) {
                mActionListener.onReportClick(mCurVideoReportBean, text);
            }
        }

    }

    class Vh extends RecyclerView.ViewHolder {

        ImageView mImg;
        TextView mText;

        public Vh(View itemView) {
            super(itemView);
            mImg = itemView.findViewById(R.id.img);
            mText = itemView.findViewById(R.id.text);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(VideoReportBean bean, int position, Object payload) {
            if (payload == null) {
                itemView.setTag(position);
                mText.setText(bean.getName());
            }
            mImg.setImageDrawable(bean.isChecked() ? mCheckedDrawable : mUnCheckedDrawable);
        }
    }

    public interface ActionListener {
        void onReportClick(VideoReportBean bean, String text);
    }

    public void setActionListener(ActionListener actionListener) {
        mActionListener = actionListener;
    }
}
