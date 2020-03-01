package com.feiyu.video.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.feiyu.common.Constants;
import com.feiyu.common.adapter.RefreshAdapter;
import com.feiyu.video.R;
import com.feiyu.video.bean.MusicBean;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.video.http.VideoHttpConsts;
import com.feiyu.video.http.VideoHttpUtil;
import com.feiyu.video.interfaces.VideoMusicActionListener;

import java.util.List;

/**
 * Created by cxf on 2018/6/20.
 */

public class MusicAdapter extends RefreshAdapter<MusicBean> {

    private static final int HEAD = 1;
    private static final int NORMAL = 0;
    private ImageView mStarView;
    private MusicBean mCollectMusicBean;
    private Drawable mStarDrawable;//收藏图标
    private Drawable mUnStarDrawable;//取消收藏图标
    private Drawable mPlayDrawable;//播放按钮
    private Drawable mPauseDrawable;//暂停按钮
    private Animation mAnimation;
    private int mCheckedPosition = -1;
    private VideoMusicActionListener mActionListener;
    private View.OnClickListener mOnStarClickListener;
    private View.OnClickListener mOnUseClickListener;
    private View.OnClickListener mOnClickListener;

    public MusicAdapter(Context context) {
        super(context);
        mStarDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_video_music_collect_1);
        mUnStarDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_video_music_collect_0);
        mPlayDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_video_music_play);
        mPauseDrawable = ContextCompat.getDrawable(context, R.mipmap.icon_video_music_pause);
        mAnimation = new ScaleAnimation(1f, 0.3f, 1f, 0.3f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        mAnimation.setDuration(200);
        mAnimation.setRepeatCount(1);
        mAnimation.setRepeatMode(Animation.REVERSE);
        mAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {


            }

            @Override
            public void onAnimationRepeat(Animation animation) {
                if (mStarView != null && mCollectMusicBean != null) {
                    if (mCollectMusicBean.getCollect() == 1) {
                        mStarView.setImageResource(R.mipmap.icon_video_music_collect_1);
                    } else {
                        mStarView.setImageResource(R.mipmap.icon_video_music_collect_0);
                    }
                }
            }
        });
        mOnStarClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!canClick()) {
                    return;
                }
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                mCollectMusicBean = mList.get(position);
                mStarView = (ImageView) v;
                VideoHttpUtil.cancel(VideoHttpConsts.SET_MUSIC_COLLECT);
                VideoHttpUtil.setMusicCollect(mCollectMusicBean.getId(), new HttpCallback() {
                    @Override
                    public void onSuccess(int code, String msg, String[] info) {
                        if (code == 0 && info.length > 0) {
                            int collect = JSON.parseObject(info[0]).getIntValue("iscollect");
                            if (mCollectMusicBean != null) {
                                mCollectMusicBean.setCollect(collect);
                                if (mStarView != null && mAnimation != null) {
                                    mStarView.startAnimation(mAnimation);
                                }
                                if (mActionListener != null) {
                                    mActionListener.onCollect(MusicAdapter.this, mCollectMusicBean.getId(), collect);
                                }
                            }
                        }
                    }
                });
            }
        };
        mOnUseClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!canClick()) {
                    return;
                }
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                MusicBean bean = mList.get(position);
                if (bean == null) {
                    return;
                }
                bean.setExpand(false);
                notifyItemChanged(position, Constants.PAYLOAD);
                mCheckedPosition = -1;
                if (mActionListener != null) {
                    mActionListener.onStopMusic();
                    mActionListener.onUseClick(bean);
                }
            }
        };
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                int position = (int) tag;
                MusicBean bean = mList.get(position);
                if (bean == null) {
                    return;
                }
                if (mCheckedPosition == position) {
                    mCheckedPosition = -1;
                    bean.setExpand(false);
                    notifyItemChanged(position, Constants.PAYLOAD);
                    if (mActionListener != null) {
                        mActionListener.onStopMusic();
                    }
                } else {
                    if (mCheckedPosition >= 0 && mCheckedPosition < mList.size()) {
                        MusicBean checkedMusicBean = mList.get(mCheckedPosition);
                        checkedMusicBean.setExpand(false);
                        notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                        if (mActionListener != null) {
                            mActionListener.onStopMusic();
                        }
                    }
                    bean.setExpand(true);
                    if (mActionListener != null) {
                        mActionListener.onPlayMusic(MusicAdapter.this, bean, position);
                    }
                    mCheckedPosition = position;
                }
            }
        };
    }

    public void setActionListener(VideoMusicActionListener actionListener) {
        mActionListener = actionListener;
    }

    @Override
    public int getItemViewType(int position) {
        if (position == 0) {
            return HEAD;
        }
        return NORMAL;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(viewType == HEAD ? R.layout.item_music_head : R.layout.item_music, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder vh, int position, @NonNull List payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        ((Vh) vh).setData(mList.get(position), position, payload);
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }


    /**
     * 显示使用按钮
     */
    public void expand(int position) {
        if (position >= 0 && position < mList.size()) {
            MusicBean bean = mList.get(position);
            if (bean != null) {
                bean.setExpand(true);
                notifyItemChanged(position, Constants.PAYLOAD);
            }
        }
    }

    /**
     * 隐藏使用按钮
     */
    public void collapse() {
        if (mCheckedPosition >= 0 && mCheckedPosition < mList.size()) {
            MusicBean bean = mList.get(mCheckedPosition);
            if (bean != null) {
                bean.setExpand(false);
                notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
            }
            mCheckedPosition = -1;
        }
    }

    /**
     * 收藏数据发生变化
     */
    public void collectChanged(MusicAdapter adapter, int musicId, int isCollect) {
        if (adapter != this) {
            for (int i = 0, size = mList.size(); i < size; i++) {
                MusicBean bean = mList.get(i);
                if (bean != null && bean.getId() == musicId) {
                    bean.setCollect(isCollect);
                    notifyItemChanged(i, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }


    class Vh extends RecyclerView.ViewHolder {

        ImageView mImg;
        TextView mTitle;
        TextView mAuthor;
        TextView mLength;
        ImageView mBtnCollect;
        View mBtnUse;
        ImageView mBtnPlay;

        public Vh(View itemView) {
            super(itemView);
            mImg = (ImageView) itemView.findViewById(R.id.img);
            mTitle = (TextView) itemView.findViewById(R.id.title);
            mAuthor = (TextView) itemView.findViewById(R.id.author);
            mLength = (TextView) itemView.findViewById(R.id.length);
            mBtnPlay = (ImageView) itemView.findViewById(R.id.btn_play);
            mBtnCollect = (ImageView) itemView.findViewById(R.id.btn_collect);
            mBtnUse = itemView.findViewById(R.id.btn_use);
            mBtnCollect.setOnClickListener(mOnStarClickListener);
            mBtnUse.setOnClickListener(mOnUseClickListener);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(MusicBean bean, int position, Object payload) {
            itemView.setTag(position);
            mBtnCollect.setTag(position);
            mBtnUse.setTag(position);
            if (payload == null) {
                ImgLoader.display(mContext,bean.getImgUrl(), mImg);
                mTitle.setText(bean.getTitle());
                mAuthor.setText(bean.getAuthor());
                mLength.setText(bean.getLength());
            }
            if (bean.getCollect() == 1) {
                mBtnCollect.setImageDrawable(mStarDrawable);
            } else {
                mBtnCollect.setImageDrawable(mUnStarDrawable);
            }
            if (bean.isExpand()) {
                mBtnPlay.setImageDrawable(mPauseDrawable);
                if (mBtnUse.getVisibility() != View.VISIBLE) {
                    mBtnUse.setVisibility(View.VISIBLE);
                }
            } else {
                mBtnPlay.setImageDrawable(mPlayDrawable);
                if (mBtnUse.getVisibility() == View.VISIBLE) {
                    mBtnUse.setVisibility(View.GONE);
                }
            }
        }
    }


}
