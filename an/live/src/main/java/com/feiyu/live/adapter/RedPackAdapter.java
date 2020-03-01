package com.feiyu.live.adapter;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.Constants;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.interfaces.OnItemClickListener;
import com.feiyu.common.utils.StringUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.R;
import com.feiyu.live.bean.RedPackBean;
import com.feiyu.live.custom.MyImageView;
import com.feiyu.live.interfaces.RedPackCountDownListener;

import java.lang.ref.WeakReference;
import java.util.List;

/**
 * Created by cxf on 2018/11/21.
 */

public class RedPackAdapter extends RecyclerView.Adapter<RedPackAdapter.Vh> {

    private Context mContext;
    private List<RedPackBean> mList;
    private LayoutInflater mInflater;
    private String mTypeString1;
    private String mTypeString2;
    private View.OnClickListener mOnClickListener;
    private OnItemClickListener<RedPackBean> mOnItemClickListener;
    private MyHandler mMyHandler;
    private RedPackCountDownListener mRedPackCountDownListener;

    public RedPackAdapter(final Context context, List<RedPackBean> list) {
        mContext=context;
        mList = list;
        mInflater = LayoutInflater.from(context);
        mTypeString1 = WordUtil.getString(R.string.red_pack_11);
        mTypeString2 = WordUtil.getString(R.string.red_pack_12);
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                if (mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick(mList.get(position), position);
                }
            }
        };
        mMyHandler = new MyHandler(this);
        for (int i = 0; i < mList.size(); i++) {
            RedPackBean bean = mList.get(i);
            if (bean != null && bean.getRobTime() != 0) {
                mMyHandler.sendEmptyMessageDelayed(i, 1000);
            }
        }
    }

    public void setOnItemClickListener(OnItemClickListener<RedPackBean> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    public void setRedPackCountDownListener(RedPackCountDownListener redPackCountDownListener) {
        mRedPackCountDownListener = redPackCountDownListener;
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_red_pack, parent, false));
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
        TextView mName;
        TextView mType;
        MyImageView mImg;
        TextView mTime;
        View mBtnRob;
        RedPackBean mRedPackBean;

        public Vh(View itemView) {
            super(itemView);
            mAvatar = (ImageView) itemView.findViewById(R.id.avatar);
            mName = (TextView) itemView.findViewById(R.id.name);
            mType = (TextView) itemView.findViewById(R.id.type);
            mImg = (MyImageView) itemView.findViewById(R.id.img);
            mTime = (TextView) itemView.findViewById(R.id.time);
            mBtnRob = itemView.findViewById(R.id.btn_rob);
            mBtnRob.setOnClickListener(mOnClickListener);
        }

        void setData(RedPackBean bean, int position, Object payload) {
            mRedPackBean = bean;
            if (payload == null) {
                mBtnRob.setTag(position);
                ImgLoader.displayAvatar(mContext,bean.getAvatar(), mAvatar);
                mName.setText(bean.getUserNiceName());
                if (bean.getSendType() == Constants.RED_PACK_SEND_TIME_DELAY) {//延时红包
                    mType.setText(mTypeString2);
                } else {
                    mType.setText(mTypeString1);
                }
            }
            if (bean.getRobTime() == 0) {//即使红包或者延时红包时间走完
                mTime.setTextColor(0xffff0000);
                mTime.setText(R.string.red_pack_10);
                if(bean.getIsRob() == 1){//可以抢
                    mImg.startAnim();
                }else{//不能抢(已经抢过)
                    mImg.stopAnim();
                }
            }else{//延时红包时间未走完，展示倒计时
                mTime.setTextColor(0xff323232);
                mTime.setText(StringUtil.getDurationText(bean.getRobTime() * 1000));
                mImg.stopAnim();
            }
        }

        void stopAnim() {
            if (mImg != null) {
                mImg.stopAnim();
            }
        }

        void checkStartAnim() {
            if (mRedPackBean != null && mRedPackBean.getIsRob() == 1 && mRedPackBean.getRobTime() == 0) {
                if (mImg != null) {
                    mImg.startAnim();
                }
            }
        }
    }

    @Override
    public void onViewAttachedToWindow(@NonNull Vh vh) {
        vh.checkStartAnim();
    }

    @Override
    public void onViewDetachedFromWindow(@NonNull Vh vh) {
        vh.stopAnim();
    }

    public void onRobClick(int redPackId) {
        for (int i = 0, size = mList.size(); i < size; i++) {
            RedPackBean bean = mList.get(i);
            if (bean.getId() == redPackId) {
                bean.setIsRob(0);
                notifyItemChanged(i, Constants.PAYLOAD);
                break;
            }
        }
    }

    private void updateItem(int position) {
        if (position >= 0 && position < mList.size()) {
            RedPackBean bean = mList.get(position);
            if (bean != null) {
                int robTime = bean.getRobTime();
                robTime--;
                bean.setRobTime(robTime);
                notifyItemChanged(position, Constants.PAYLOAD);
                if (robTime > 0) {
                    if (mMyHandler != null) {
                        mMyHandler.sendEmptyMessageDelayed(position, 1000);
                    }
                }
                if (mRedPackCountDownListener != null && bean.getId() == mRedPackCountDownListener.getRedPackId()) {
                    mRedPackCountDownListener.onCountDown(robTime);
                }
            }
        }
    }

    public void postDelay(Runnable runnable, long delayTime) {
        if (mMyHandler != null) {
            mMyHandler.postDelayed(runnable, delayTime);
        }
    }

    public void release() {
        if (mList != null) {
            mList.clear();
        }
        if (mMyHandler != null) {
            mMyHandler.removeCallbacksAndMessages(null);
            mMyHandler.release();
        }
        mMyHandler = null;
        mRedPackCountDownListener = null;
    }

    private static class MyHandler extends Handler {

        private RedPackAdapter mRedPackAdapter;

        public MyHandler(RedPackAdapter adapter) {
            mRedPackAdapter = new WeakReference<>(adapter).get();
        }

        @Override
        public void handleMessage(Message msg) {
            if (mRedPackAdapter != null) {
                mRedPackAdapter.updateItem(msg.what);
            }
        }

        void release() {
            mRedPackAdapter = null;
        }
    }
}
