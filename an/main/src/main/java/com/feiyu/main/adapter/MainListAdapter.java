package com.feiyu.main.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.Constants;
import com.feiyu.common.adapter.RefreshAdapter;
import com.feiyu.common.bean.LevelBean;
import com.feiyu.common.custom.MyRadioButton;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.CommonHttpUtil;
import com.feiyu.common.utils.CommonIconUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.main.R;
import com.feiyu.main.bean.ListBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by cxf on 2018/9/27.
 */

public class MainListAdapter extends RefreshAdapter<ListBean> {

    public static final int TYPE_PROFIT = 1;//收益榜
    public static final int TYPE_CONTRIBUTE = 0;//贡献榜
    private static final int HEAD = 0;
    private static final int NORMAL = 1;
    private String mCoinName;
    private String mFollow;
    private String mFollowing;
    private View.OnClickListener mFollowClickListener1;
    private View.OnClickListener mFollowClickListener2;
    private View.OnClickListener mItemClickListener;
    private List<ListBean> mTopList;
    private HeadVh mHeadVh;
    private int mType;

    public MainListAdapter(Context context, int type) {
        super(context);
        mType = type;
        CommonAppConfig appConfig = CommonAppConfig.getInstance();
        mCoinName = type == TYPE_PROFIT ? appConfig.getVotesName() : appConfig.getCoinName();
        mTopList = new ArrayList<>();
        mFollow = WordUtil.getString(R.string.follow);
        mFollowing = WordUtil.getString(R.string.following);
        mItemClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag != null && mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick((ListBean) tag, 0);
                }
            }
        };
        mFollowClickListener1 = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!canClick()) {
                    return;
                }
                Object tag = v.getTag();
                if (tag != null) {
                    final ListBean bean = (ListBean) tag;
                    CommonHttpUtil.setAttention(bean.getUid(), null);
                }
            }
        };
        mFollowClickListener2 = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!canClick()) {
                    return;
                }
                Object tag = v.getTag();
                if (tag != null) {
                    final int position = (int) tag;
                    final ListBean bean = mList.get(position);
                    CommonHttpUtil.setAttention(bean.getUid(), null);
                }
            }
        };

    }

    @Override
    public int getItemCount() {
        if (mList != null && mTopList.size() > 0) {
            return mList.size() + 1;
        }
        return 0;
    }

    @Override
    public void clearData() {
        mTopList.clear();
        super.clearData();
    }

    @Override
    public void insertList(List<ListBean> list) {
        if (mRecyclerView != null && mList != null && list != null && list.size() > 0) {
            int p = mList.size() + 1;
            mList.addAll(list);
            notifyItemRangeInserted(p, list.size());
        }
    }

    @Override
    public void refreshData(List<ListBean> list) {
        mTopList.clear();
        int size = list.size();
        if (size > 0) {
            mTopList.add(list.get(0));
        }
        if (size > 1) {
            mTopList.add(list.get(1));
        }
        if (size > 2) {
            mTopList.add(list.get(2));
        }
        if (size <= 3) {
            list = new ArrayList<>();
        } else {
            list = list.subList(3, list.size());
        }
        super.refreshData(list);
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
        if (viewType == HEAD) {
            if (mHeadVh == null) {
                mHeadVh = new HeadVh(mInflater.inflate(R.layout.item_main_list_head, parent, false));
            }
            return mHeadVh;
        } else {
            return new Vh(mInflater.inflate(R.layout.item_main_list, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder vh, int position, @NonNull List payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        if (vh instanceof Vh) {
            ((Vh) vh).setData(mList.get(position - 1), position - 1, payload);
        } else {
            ((HeadVh) vh).setData(payload);
        }
    }

    class HeadVh extends RecyclerView.ViewHolder {

        View mItem1;
        View mItem2;
        View mItem3;
        ImageView mAvatar1;
        ImageView mAvatar2;
        ImageView mAvatar3;
        TextView mName1;
        TextView mName2;
        TextView mName3;
        TextView mVotes1;
        TextView mVotes2;
        TextView mVotes3;
        ImageView mSex1;
        ImageView mSex2;
        ImageView mSex3;
        ImageView mLevel1;
        ImageView mLevel2;
        ImageView mLevel3;
        MyRadioButton mBtnFollow1;
        MyRadioButton mBtnFollow2;
        MyRadioButton mBtnFollow3;
        View mDataGroup2;
        View mDataGroup3;
        View mNoData2;
        View mNoData3;

        public HeadVh(View itemView) {
            super(itemView);
            mItem1 = itemView.findViewById(R.id.item_1);
            mItem2 = itemView.findViewById(R.id.item_2);
            mItem3 = itemView.findViewById(R.id.item_3);
            mItem1.setOnClickListener(mItemClickListener);
            mItem2.setOnClickListener(mItemClickListener);
            mItem3.setOnClickListener(mItemClickListener);
            mAvatar1 = (ImageView) itemView.findViewById(R.id.avatar_1);
            mAvatar2 = (ImageView) itemView.findViewById(R.id.avatar_2);
            mAvatar3 = (ImageView) itemView.findViewById(R.id.avatar_3);
            mName1 = (TextView) itemView.findViewById(R.id.name_1);
            mName2 = (TextView) itemView.findViewById(R.id.name_2);
            mName3 = (TextView) itemView.findViewById(R.id.name_3);
            mVotes1 = (TextView) itemView.findViewById(R.id.votes_1);
            mVotes2 = (TextView) itemView.findViewById(R.id.votes_2);
            mVotes3 = (TextView) itemView.findViewById(R.id.votes_3);
            mSex1 = (ImageView) itemView.findViewById(R.id.sex_1);
            mSex2 = (ImageView) itemView.findViewById(R.id.sex_2);
            mSex3 = (ImageView) itemView.findViewById(R.id.sex_3);
            mLevel1 = (ImageView) itemView.findViewById(R.id.level_1);
            mLevel2 = (ImageView) itemView.findViewById(R.id.level_2);
            mLevel3 = (ImageView) itemView.findViewById(R.id.level_3);
            mBtnFollow1 = (MyRadioButton) itemView.findViewById(R.id.btn_follow_1);
            mBtnFollow2 = (MyRadioButton) itemView.findViewById(R.id.btn_follow_2);
            mBtnFollow3 = (MyRadioButton) itemView.findViewById(R.id.btn_follow_3);
            mBtnFollow1.setOnClickListener(mFollowClickListener1);
            mBtnFollow2.setOnClickListener(mFollowClickListener1);
            mBtnFollow3.setOnClickListener(mFollowClickListener1);
            mDataGroup2 = itemView.findViewById(R.id.data_group_2);
            mDataGroup3 = itemView.findViewById(R.id.data_group_3);
            mNoData2 = itemView.findViewById(R.id.no_data_2);
            mNoData3 = itemView.findViewById(R.id.no_data_3);
        }

        void setData(Object payload) {
            int topSize = mTopList.size();
            if (topSize > 0) {
                ListBean bean = mTopList.get(0);
                if (payload == null) {
                    mItem1.setTag(bean);
                    ImgLoader.display(mContext,bean.getAvatarThumb(), mAvatar1);
                    mName1.setText(bean.getUserNiceName());
                    mVotes1.setText(bean.getTotalCoinFormat() + " " + mCoinName);
                    mSex1.setImageResource(CommonIconUtil.getSexIcon(bean.getSex()));
                    LevelBean levelBean = null;
                    if (mType == TYPE_PROFIT) {
                        levelBean = CommonAppConfig.getInstance().getAnchorLevel(bean.getLevelAnchor());
                    } else {
                        levelBean = CommonAppConfig.getInstance().getLevel(bean.getLevel());
                    }
                    if (levelBean != null) {
                        ImgLoader.display(mContext,levelBean.getThumb(), mLevel1);
                    }
                }
                mBtnFollow1.setTag(bean);
                if (bean.getAttention() == 1) {
                    mBtnFollow1.doChecked(true);
                    mBtnFollow1.setText(mFollowing);
                } else {
                    mBtnFollow1.doChecked(false);
                    mBtnFollow1.setText(mFollow);
                }
            }
            if (topSize > 1) {
                ListBean bean = mTopList.get(1);
                if (payload == null) {
                    mItem2.setTag(bean);
                    ImgLoader.display(mContext,bean.getAvatarThumb(), mAvatar2);
                    mName2.setText(bean.getUserNiceName());
                    mVotes2.setText(bean.getTotalCoinFormat() + " " + mCoinName);
                    mSex2.setImageResource(CommonIconUtil.getSexIcon(bean.getSex()));
                    LevelBean levelBean = null;
                    if (mType == TYPE_PROFIT) {
                        levelBean = CommonAppConfig.getInstance().getAnchorLevel(bean.getLevelAnchor());
                    } else {
                        levelBean = CommonAppConfig.getInstance().getLevel(bean.getLevel());
                    }
                    if (levelBean != null) {
                        ImgLoader.display(mContext,levelBean.getThumb(), mLevel2);
                    }
                }
                mBtnFollow2.setTag(bean);
                if (bean.getAttention() == 1) {
                    mBtnFollow2.doChecked(true);
                    mBtnFollow2.setText(mFollowing);
                } else {
                    mBtnFollow2.doChecked(false);
                    mBtnFollow2.setText(mFollow);
                }
                if (mNoData2.getVisibility() == View.VISIBLE) {
                    mNoData2.setVisibility(View.INVISIBLE);
                }
                if (mDataGroup2.getVisibility() != View.VISIBLE) {
                    mDataGroup2.setVisibility(View.VISIBLE);
                }
            } else {
                if (mDataGroup2.getVisibility() == View.VISIBLE) {
                    mDataGroup2.setVisibility(View.INVISIBLE);
                }
                if (mNoData2.getVisibility() != View.VISIBLE) {
                    mNoData2.setVisibility(View.VISIBLE);
                }
            }
            if (topSize > 2) {
                ListBean bean = mTopList.get(2);
                if (payload == null) {
                    mItem3.setTag(bean);
                    ImgLoader.display(mContext,bean.getAvatarThumb(), mAvatar3);
                    mName3.setText(bean.getUserNiceName());
                    mVotes3.setText(bean.getTotalCoinFormat() + " " + mCoinName);
                    mSex3.setImageResource(CommonIconUtil.getSexIcon(bean.getSex()));
                    LevelBean levelBean = null;
                    if (mType == TYPE_PROFIT) {
                        levelBean = CommonAppConfig.getInstance().getAnchorLevel(bean.getLevelAnchor());
                    } else {
                        levelBean = CommonAppConfig.getInstance().getLevel(bean.getLevel());
                    }
                    if (levelBean != null) {
                        ImgLoader.display(mContext,levelBean.getThumb(), mLevel3);
                    }
                }
                mBtnFollow3.setTag(bean);
                if (bean.getAttention() == 1) {
                    mBtnFollow3.doChecked(true);
                    mBtnFollow3.setText(mFollowing);
                } else {
                    mBtnFollow3.doChecked(false);
                    mBtnFollow3.setText(mFollow);
                }
                if (mNoData3.getVisibility() == View.VISIBLE) {
                    mNoData3.setVisibility(View.INVISIBLE);
                }
                if (mDataGroup3.getVisibility() != View.VISIBLE) {
                    mDataGroup3.setVisibility(View.VISIBLE);
                }
            } else {
                if (mDataGroup3.getVisibility() == View.VISIBLE) {
                    mDataGroup3.setVisibility(View.INVISIBLE);
                }
                if (mNoData3.getVisibility() != View.VISIBLE) {
                    mNoData3.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    class Vh extends RecyclerView.ViewHolder {

        TextView mOrder;
        ImageView mAvatar;
        TextView mName;
        TextView mVotes;
        MyRadioButton mBtnFollow;
        ImageView mSex;
        ImageView mLevel;

        public Vh(View itemView) {
            super(itemView);
            mOrder = (TextView) itemView.findViewById(R.id.order);
            mAvatar = (ImageView) itemView.findViewById(R.id.avatar);
            mName = (TextView) itemView.findViewById(R.id.name);
            mVotes = (TextView) itemView.findViewById(R.id.votes);
            mSex = itemView.findViewById(R.id.sex);
            mLevel = itemView.findViewById(R.id.level);
            mBtnFollow = (MyRadioButton) itemView.findViewById(R.id.btn_follow);
            mBtnFollow.setOnClickListener(mFollowClickListener2);
            itemView.setOnClickListener(mItemClickListener);
        }

        void setData(ListBean bean, int position, Object payload) {
            if (payload == null) {
                itemView.setTag(bean);
                mOrder.setText("NO." + (position + 4));
                ImgLoader.display(mContext,bean.getAvatarThumb(), mAvatar);
                mName.setText(bean.getUserNiceName());
                mVotes.setText(bean.getTotalCoinFormat() + " " + mCoinName);
                mSex.setImageResource(CommonIconUtil.getSexIcon(bean.getSex()));
                LevelBean levelBean = null;
                if (mType == TYPE_PROFIT) {
                    levelBean = CommonAppConfig.getInstance().getAnchorLevel(bean.getLevelAnchor());
                } else {
                    levelBean = CommonAppConfig.getInstance().getLevel(bean.getLevel());
                }
                if (levelBean != null) {
                    ImgLoader.display(mContext,levelBean.getThumb(), mLevel);
                }
            }
            mBtnFollow.setTag(position);
            if (bean.getAttention() == 1) {
                mBtnFollow.doChecked(true);
                mBtnFollow.setText(mFollowing);
            } else {
                mBtnFollow.doChecked(false);
                mBtnFollow.setText(mFollow);
            }
        }
    }


    public void updateItem(String id, int attention) {
        if (!TextUtils.isEmpty(id)) {
            for (ListBean bean : mTopList) {
                if (bean != null && id.equals(bean.getUid())) {
                    bean.setAttention(attention);
                    notifyItemChanged(0, Constants.PAYLOAD);
                    return;
                }
            }
            for (int i = 0, size = mList.size(); i < size; i++) {
                ListBean bean = mList.get(i);
                if (bean != null && id.equals(bean.getUid())) {
                    bean.setAttention(attention);
                    notifyItemChanged(i + 1, Constants.PAYLOAD);
                    break;
                }
            }
        }
    }

}
