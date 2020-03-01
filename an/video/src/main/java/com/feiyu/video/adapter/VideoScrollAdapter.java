package com.feiyu.video.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.PagerSnapHelper;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.util.SparseArray;
import android.view.View;
import android.view.ViewGroup;

import com.feiyu.common.Constants;
import com.feiyu.common.custom.ItemSlideHelper;
import com.feiyu.common.utils.ClickUtil;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.video.R;
import com.feiyu.video.activity.AbsVideoPlayActivity;
import com.feiyu.video.bean.VideoBean;
import com.feiyu.video.utils.VideoIconUtil;
import com.feiyu.video.views.VideoPlayWrapViewHolder;

import java.util.List;

/**
 * Created by cxf on 2018/11/27.
 */

public class VideoScrollAdapter extends RecyclerView.Adapter<VideoScrollAdapter.Vh> implements ItemSlideHelper.Callback {

    private static final String TAG = "VideoScrollAdapter";
    private static final int COUNT = 20;//接口每页返回多少条
    private Context mContext;
    private List<VideoBean> mList;
    private SparseArray<VideoPlayWrapViewHolder> mMap;
    private int mCurPosition;
    private ActionListener mActionListener;
    private boolean mFirstLoad;
    private RecyclerView mRecyclerView;
    private LinearLayoutManager mLayoutManager;
    private Drawable[] mLikeAnimDrawables;
    private Handler mHandler;

    public VideoScrollAdapter(Context context, List<VideoBean> list, int curPosition) {
        mContext = context;
        mList = list;
        mCurPosition = curPosition;
        mMap = new SparseArray<>();
        mFirstLoad = true;
        List<Integer> likeImageList = VideoIconUtil.getVideoLikeAnim();//点赞帧动画
        mLikeAnimDrawables = new Drawable[likeImageList.size()];
        for (int i = 0, length = mLikeAnimDrawables.length; i < length; i++) {
            mLikeAnimDrawables[i] = ContextCompat.getDrawable(context, likeImageList.get(i));
        }
    }

    public void setActionListener(ActionListener actionListener) {
        mActionListener = actionListener;
    }

    @NonNull
    @Override
    public Vh onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        VideoPlayWrapViewHolder vpvh = new VideoPlayWrapViewHolder(mContext, parent);
        vpvh.setLikeAnimDrawables(mLikeAnimDrawables);
        return new Vh(vpvh);
    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position) {

    }

    @Override
    public void onBindViewHolder(@NonNull Vh vh, int position, @NonNull List<Object> payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        vh.setData(mList.get(position), position, payload);
        if (mFirstLoad) {
            mFirstLoad = false;
            VideoPlayWrapViewHolder vpvh = mMap.get(mCurPosition);
            if (vpvh != null && mActionListener != null) {
                vpvh.onPageSelected();
                mActionListener.onPageSelected(vpvh, mList.size() >= COUNT && mCurPosition == mList.size() - 1);
            }
        }
    }


    @Override
    public void onViewRecycled(@NonNull Vh vh) {
        vh.reycle();
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    /**
     * 视频数据发生变化，更新item
     */
    public void onVideoBeanChanged(String changedVideoId) {
        if (TextUtils.isEmpty(changedVideoId)) {
            return;
        }
        for (int i = 0, size = mList.size(); i < size; i++) {
            VideoBean bean = mList.get(i);
            if (bean != null) {
                if (changedVideoId.equals(bean.getId())) {
                    notifyItemChanged(i, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }

    /**
     * 删除视频
     */
    public void deleteVideo(VideoBean videoBean) {
        if (videoBean == null) {
            return;
        }
        String videoId = videoBean.getId();
        if (TextUtils.isEmpty(videoId)) {
            return;
        }
        for (int i = 0, size = mList.size(); i < size; i++) {
            VideoBean bean = mList.get(i);
            if (videoId.equals(bean.getId())) {
                mList.remove(i);
                notifyItemRemoved(i);
                size = mList.size();
                if (size > 0) {
                    notifyItemRangeChanged(i, size);
                    if (mHandler == null) {
                        mHandler = new Handler();
                    }
                    mHandler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            mCurPosition = -1;
                            findCurVideo();
                        }
                    }, 500);
                } else {
                    if (mActionListener != null) {
                        mActionListener.onVideoDeleteAll();
                    }
                }
                break;
            }
        }
    }

    /**
     * ItemSlideHelper回调
     */
    @Override
    public int getHorizontalRange(RecyclerView.ViewHolder holder) {
        return 0;
    }

    /**
     * ItemSlideHelper回调
     */
    @Override
    public RecyclerView.ViewHolder getChildViewHolder(View childView) {
        if (mRecyclerView != null && childView != null) {
            return mRecyclerView.getChildViewHolder(childView);
        }
        return null;
    }

    /**
     * ItemSlideHelper回调
     */
    @Override
    public View findTargetView(float x, float y) {
        return mRecyclerView.findChildViewUnder(x, y);
    }

    @Override
    public boolean useLeftScroll() {
        return false;
    }

    @Override
    public void onLeftScroll(RecyclerView.ViewHolder vh) {
        if (((AbsVideoPlayActivity) mContext).isPaused()) {
            return;
        }
        if (!ClickUtil.canClick()) {
            return;
        }
        if (vh != null) {
            VideoPlayWrapViewHolder vpvh = ((Vh) vh).mVideoPlayWrapViewHolder;
            if (vpvh != null) {
                vpvh.clickAvatar();
            }
        }
    }


    class Vh extends RecyclerView.ViewHolder {

        VideoPlayWrapViewHolder mVideoPlayWrapViewHolder;

        public Vh(VideoPlayWrapViewHolder videoPlayWrapViewHolder) {
            super(videoPlayWrapViewHolder.getContentView());
            mVideoPlayWrapViewHolder = videoPlayWrapViewHolder;
        }

        void setData(VideoBean bean, int position, Object payload) {
            if (mVideoPlayWrapViewHolder != null) {
                mMap.put(position, mVideoPlayWrapViewHolder);
                mVideoPlayWrapViewHolder.setData(bean, payload);
            }
        }

        void reycle() {
            if (mVideoPlayWrapViewHolder != null) {
                mVideoPlayWrapViewHolder.release();
            }
        }
    }


    @Override
    public void onViewDetachedFromWindow(@NonNull Vh vh) {
        VideoPlayWrapViewHolder vpvh = vh.mVideoPlayWrapViewHolder;
        if (vpvh != null) {
            vpvh.onPageOutWindow();
            if (mActionListener != null) {
                mActionListener.onPageOutWindow(vpvh);
            }
        }
    }

    @Override
    public void onViewAttachedToWindow(@NonNull Vh vh) {
        VideoPlayWrapViewHolder vpvh = vh.mVideoPlayWrapViewHolder;
        if (vpvh != null) {
            vpvh.onPageInWindow();
        }
    }

    @Override
    public void onAttachedToRecyclerView(@NonNull final RecyclerView recyclerView) {
        mRecyclerView = recyclerView;
        mRecyclerView.addOnItemTouchListener(new ItemSlideHelper(mContext, this));
        mLayoutManager = (LinearLayoutManager) recyclerView.getLayoutManager();
        mLayoutManager.setInitialPrefetchItemCount(4);
        recyclerView.scrollToPosition(mCurPosition);
        PagerSnapHelper pagerSnapHelper = new PagerSnapHelper();
        pagerSnapHelper.attachToRecyclerView(recyclerView);
        recyclerView.setOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                findCurVideo();
            }
        });
    }

    private void findCurVideo() {
        int position = mLayoutManager.findFirstCompletelyVisibleItemPosition();
        if (position >= 0 && mCurPosition != position) {
            if (mHandler != null) {
                mHandler.removeCallbacksAndMessages(null);
            }
            VideoPlayWrapViewHolder vh = mMap.get(position);
            if (vh != null && mActionListener != null) {
                vh.onPageSelected();
                boolean needLoadMore = false;
                if (position == mList.size() - 1) {
                    if (mList.size() < COUNT) {
                        ToastUtil.show(R.string.video_no_more_video);
                    } else {
                        needLoadMore = true;
                    }
                }
                mActionListener.onPageSelected(vh, needLoadMore);
            }
            mCurPosition = position;
            if (position == 0) {
                ToastUtil.show(R.string.video_scroll_top);
            }
        }
    }

    /**
     * 插入数据
     */
    public void insertList(List<VideoBean> list) {
        if (list != null && list.size() > 0 && mList != null && mRecyclerView != null) {
            int position = mList.size();
            mList.addAll(list);
            notifyItemRangeInserted(position, list.size());
        }
    }


    /**
     * 刷新列表
     */
    public void setList(List<VideoBean> list) {
        if (list != null && list.size() > 0 && mList != null && mRecyclerView != null) {
            mList.clear();
            mList.addAll(list);
            mFirstLoad = true;
            mCurPosition = 0;
            notifyDataSetChanged();
        }
    }

    /**
     * 关注发生变化
     */
    public void onFollowChanged(boolean needExclude, String excludeVideoId, String toUid, int isAttention) {
        if (mList != null && !TextUtils.isEmpty(toUid) && !TextUtils.isEmpty(excludeVideoId)) {
            for (int i = 0, size = mList.size(); i < size; i++) {
                VideoBean videoBean = mList.get(i);
                if (videoBean != null) {
                    if (needExclude && excludeVideoId.equals(videoBean.getId())) {
                        continue;
                    }
                    if (toUid.equals(videoBean.getUid())) {
                        videoBean.setAttent(isAttention);
                        notifyItemChanged(i, Constants.PAYLOAD);
                    }
                }
            }
        }
    }

    /**
     * 点赞发生变化
     */
    public void onLikeChanged(boolean needExclude, String videoId, int like, String likeNum) {
        if (mList != null && !TextUtils.isEmpty(videoId)) {
            for (int i = 0, size = mList.size(); i < size; i++) {
                VideoBean videoBean = mList.get(i);
                if (videoBean != null && videoId.equals(videoBean.getId()) && !needExclude) {
                    videoBean.setLike(like);
                    videoBean.setLikeNum(likeNum);
                    notifyItemChanged(i, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }

    /**
     * 评论数发生变化
     */
    public void onCommentChanged(String videoId, String commentNum) {
        if (mList != null && !TextUtils.isEmpty(videoId)) {
            for (int i = 0, size = mList.size(); i < size; i++) {
                VideoBean videoBean = mList.get(i);
                if (videoBean != null && videoId.equals(videoBean.getId())) {
                    videoBean.setCommentNum(commentNum);
                    notifyItemChanged(i, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }

    /**
     * 分享数发生变化
     */
    public void onShareChanged(String videoId, String shareNum) {
        if (mList != null && !TextUtils.isEmpty(videoId)) {
            for (int i = 0, size = mList.size(); i < size; i++) {
                VideoBean videoBean = mList.get(i);
                if (videoBean != null && videoId.equals(videoBean.getId())) {
                    videoBean.setShareNum(shareNum);
                    notifyItemChanged(i, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }

    public void release() {
        mActionListener = null;
        if (mHandler != null) {
            mHandler.removeCallbacksAndMessages(null);
        }
        mHandler = null;
    }


    public interface ActionListener {
        void onPageSelected(VideoPlayWrapViewHolder vh, boolean needLoadMore);

        void onPageOutWindow(VideoPlayWrapViewHolder vh);

        void onVideoDeleteAll();
    }

}
