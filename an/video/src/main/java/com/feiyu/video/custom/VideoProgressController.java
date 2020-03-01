package com.feiyu.video.custom;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by vinsonswang on 2017/11/6.
 */

public class VideoProgressController {

    private Context mContext;
    private VideoProgressView mVideoProgressView;
    private RecyclerView mRecyclerView;
    private boolean mIsTouching;
    private int mScrollState;
    private float mCurrentScroll;
    private long mCurrentTimeMs;
    private long mTotalDurationMs; // us
    private float mThumbnailPicListDisplayWidth; // 视频缩略图列表的宽度
    private float mVideoProgressDisplayWidth; // 视频进度条可显示宽度
    private int mThumbnailNum;
    private VideoProgressSeekListener mVideoProgressSeekListener;
    private float mScale;
    private int mFrameWidth;
    private List<RangeSliderViewContainer> mRangeSliderViewContainerList;
    private boolean mIsRangeSliderChanged;
    private ColorfulProgress mColorfulProgress;
    private List<SliderViewContainer> mSliderViewContainerList;


    public VideoProgressController(Context context, long durationMs) {
        mContext = context;
        DisplayMetrics dm = mContext.getResources().getDisplayMetrics();
        mVideoProgressDisplayWidth = dm.widthPixels;
        mScale = dm.density;
        mFrameWidth = dp2px(30);
        mTotalDurationMs = durationMs;
    }

    public void addRangeSliderView(final RangeSliderViewContainer rangeSliderView) {
        if (rangeSliderView == null) {
            return;
        }
        if (mRangeSliderViewContainerList == null) {
            mRangeSliderViewContainerList = new ArrayList<>();
        }
        mRangeSliderViewContainerList.add(rangeSliderView);
        mVideoProgressView.getParentView().addView(rangeSliderView);
        rangeSliderView.post(new Runnable() {
            @Override
            public void run() {
                rangeSliderView.changeStartViewLayoutParams();
            }
        });
    }

    public boolean removeRangeSliderView(RangeSliderViewContainer rangeSliderView) {
        if (mVideoProgressView == null) {
            return false;
        }
        mVideoProgressView.getParentView().removeView(rangeSliderView);
        if (mRangeSliderViewContainerList == null || mRangeSliderViewContainerList.size() == 0) {
            return false;
        }
        return mRangeSliderViewContainerList.remove(rangeSliderView);
    }

    public View removeRangeSliderView(int index) {
        if (mVideoProgressView == null) {
            return null;
        }
        if (mRangeSliderViewContainerList == null || mRangeSliderViewContainerList.size() == 0) {
            return null;
        }
        if (index > mRangeSliderViewContainerList.size() - 1) {
            return null;
        }
        RangeSliderViewContainer view = mRangeSliderViewContainerList.remove(index);
        mVideoProgressView.getParentView().removeView(view);
        return view;
    }

    public RangeSliderViewContainer getRangeSliderView(int index) {
        if (mRangeSliderViewContainerList != null && index < mRangeSliderViewContainerList.size() && index >= 0) {
            return mRangeSliderViewContainerList.get(index);
        }
        return null;
    }

    public void addColorfulProgress(ColorfulProgress colorfulProgress) {
        if (colorfulProgress == null) {
            return;
        }
        colorfulProgress.setVideoProgressController(this);
        mColorfulProgress = colorfulProgress;
        mVideoProgressView.getParentView().addView(colorfulProgress);
        mColorfulProgress.post(new Runnable() {
            @Override
            public void run() {
                changeColorfulProgressOffset();
            }
        });
    }

    private void changeColorfulProgressOffset() {
        if (mColorfulProgress == null) {
            return;
        }
        ViewGroup.MarginLayoutParams layoutParams = (ViewGroup.MarginLayoutParams) mColorfulProgress.getLayoutParams();
        layoutParams.leftMargin = calculateColorfulProgressOffset();
        mColorfulProgress.requestLayout();
    }

    public void removeColorfulProgress() {
        if (mColorfulProgress != null) {
            mVideoProgressView.getParentView().removeView(mColorfulProgress);
        }
    }

    public void addSliderView(final SliderViewContainer sliderViewContainer) {
        if (sliderViewContainer == null) {
            return;
        }
        if (mSliderViewContainerList == null) {
            mSliderViewContainerList = new ArrayList<>();
        }
        mSliderViewContainerList.add(sliderViewContainer);
        sliderViewContainer.setVideoProgressControlloer(this);
        mVideoProgressView.getParentView().addView(sliderViewContainer);
        sliderViewContainer.post(new Runnable() {
            @Override
            public void run() {
                sliderViewContainer.changeLayoutParams();
            }
        });
    }

    public boolean removeSliderView(SliderViewContainer sliderViewContainer) {
        if (mVideoProgressView == null) {
            return false;
        }
        mVideoProgressView.getParentView().removeView(sliderViewContainer);
        if (mSliderViewContainerList == null || mSliderViewContainerList.size() == 0) {
            return false;
        }
        return mSliderViewContainerList.remove(sliderViewContainer);
    }

    public View removeSliderView(int index) {
        if (mVideoProgressView == null) {
            return null;
        }
        if (mSliderViewContainerList == null || mSliderViewContainerList.size() == 0) {
            return null;
        }
        if (index > mSliderViewContainerList.size() - 1) {
            return null;
        }
        SliderViewContainer sliderViewContainer = mSliderViewContainerList.get(index);
        mVideoProgressView.getParentView().removeView(sliderViewContainer);
        return sliderViewContainer;
    }


    int calculateStartViewPosition(RangeSliderViewContainer rangeSliderView) {
        return (int) (mVideoProgressDisplayWidth / 2 - rangeSliderView.getStartView().getMeasuredWidth()
                + duration2Distance(rangeSliderView.getStartTimeUs()) - mCurrentScroll);
    }

    int calculateSliderViewPosition(SliderViewContainer sliderViewContainer) {
        return (int) (mVideoProgressDisplayWidth / 2 + duration2Distance(sliderViewContainer.getStartTimeMs()) - mCurrentScroll);
    }

    int calculateColorfulProgressOffset() {
        return (int) (mVideoProgressDisplayWidth / 2 - mCurrentScroll);
    }

    public int duration2Distance(long durationMs) {
        float rate = durationMs * 1.0f / mTotalDurationMs;
        return (int) (getThumbnailPicListDisplayWidth() * rate);
    }

    long distance2Duration(float distance) {
        float rate = distance / getThumbnailPicListDisplayWidth();
        return (long) (mTotalDurationMs * rate);
    }

    public void setVideoProgressSeekListener(VideoProgressSeekListener videoProgressSeekListener) {
        mVideoProgressSeekListener = videoProgressSeekListener;
    }

    public void setVideoProgressView(VideoProgressView videoProgressView) {
        mVideoProgressView = videoProgressView;
        mRecyclerView = mVideoProgressView.getRecyclerView();
        mRecyclerView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                int eventId = motionEvent.getAction();
                switch (eventId) {
                    case MotionEvent.ACTION_DOWN:
                        mIsTouching = true;
                        break;
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        mIsTouching = false;
                        break;
                }
                return false;
            }
        });

        mRecyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);

                switch (newState) {
                    case RecyclerView.SCROLL_STATE_IDLE:

                        if (mVideoProgressSeekListener != null) {
                            mVideoProgressSeekListener.onVideoProgressSeekFinish(mCurrentTimeMs);
                        }
                        if (mRangeSliderViewContainerList != null && mRangeSliderViewContainerList.size() > 0) {
                            for (RangeSliderViewContainer rangeSliderView : mRangeSliderViewContainerList) {
                                rangeSliderView.changeStartViewLayoutParams();
                            }
                        }

                        if (mColorfulProgress != null) {
                            mColorfulProgress.setCurPosition(mCurrentScroll);
                            changeColorfulProgressOffset();
                        }

                        if (mSliderViewContainerList != null && mSliderViewContainerList.size() > 0) {
                            for (SliderViewContainer sliderViewContainer : mSliderViewContainerList) {
                                sliderViewContainer.changeLayoutParams();
                            }
                        }

                        break;
                    case RecyclerView.SCROLL_STATE_DRAGGING:

                        break;
                    case RecyclerView.SCROLL_STATE_SETTLING:

                        break;
                }
                mScrollState = newState;
            }

            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);

                mCurrentScroll = mCurrentScroll + dx;
                float rate = mCurrentScroll / getThumbnailPicListDisplayWidth();
                long currentTimeUs = (long) (rate * mTotalDurationMs);


                if (mIsTouching || mIsRangeSliderChanged || mScrollState == RecyclerView.SCROLL_STATE_SETTLING) {
                    mIsRangeSliderChanged = false; // 由于范围改变引起的，回调给界面后保证能单帧预览，之后马上重置
                    if (mVideoProgressSeekListener != null) {
                        mVideoProgressSeekListener.onVideoProgressSeek(currentTimeUs);
                    }
                }
                mCurrentTimeMs = currentTimeUs;
                if (mRangeSliderViewContainerList != null && mRangeSliderViewContainerList.size() > 0) {
                    for (RangeSliderViewContainer rangeSliderView : mRangeSliderViewContainerList) {
                        rangeSliderView.changeStartViewLayoutParams();
                    }
                }

                if (mColorfulProgress != null) {
                    mColorfulProgress.setCurPosition(mCurrentScroll);
                    changeColorfulProgressOffset();
                }
                if (mSliderViewContainerList != null && mSliderViewContainerList.size() > 0) {
                    for (SliderViewContainer sliderViewContainer : mSliderViewContainerList) {
                        sliderViewContainer.changeLayoutParams();
                    }
                }
            }
        });
    }

    /**
     * 当前时间ms
     *
     * @param currentTimeMs
     */
    public void setCurrentTimeMs(long currentTimeMs) {
        mCurrentTimeMs = currentTimeMs;
        float rate = (float) mCurrentTimeMs / mTotalDurationMs;
        float scrollBy = rate * getThumbnailPicListDisplayWidth() - mCurrentScroll;
        mRecyclerView.scrollBy((int) scrollBy, 0);
    }

    public long getCurrentTimeMs() {
        return mCurrentTimeMs;
    }

    public long getTotalDurationMs() {
        return mTotalDurationMs;
    }

    public void setIsRangeSliderChanged(boolean isRangeSliderChanged) {
        mIsRangeSliderChanged = isRangeSliderChanged;
    }

    private void scroll(float rate) {

    }

    /**
     * 获取缩略图列表的长度，需要在设置完数据之后调用，否则返回0
     *
     * @return
     */
    public float getThumbnailPicListDisplayWidth() {
        if (mThumbnailPicListDisplayWidth == 0) {
            mThumbnailNum = mVideoProgressView.getThumbnailCount();
            mThumbnailPicListDisplayWidth = mThumbnailNum * mFrameWidth;
        }
        return mThumbnailPicListDisplayWidth;
    }

    public interface VideoProgressSeekListener {
        void onVideoProgressSeek(long currentTimeMs);

        void onVideoProgressSeekFinish(long currentTimeMs);
    }

    private int dp2px(int dpVal) {
        return (int) (mScale * dpVal + 0.5f);
    }

}
