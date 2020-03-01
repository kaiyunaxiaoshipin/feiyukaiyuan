package com.feiyu.live.views;

import android.content.Context;
import android.support.v7.widget.LinearLayoutManager;
import android.view.ViewGroup;

import com.alibaba.fastjson.JSON;
import com.feiyu.common.adapter.RefreshAdapter;
import com.feiyu.common.custom.CommonRefreshView;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.interfaces.OnItemClickListener;
import com.feiyu.live.R;
import com.feiyu.live.activity.RoomManageDetailActivity;
import com.feiyu.live.adapter.LiveAdminRoomAdapter;
import com.feiyu.live.bean.LiveAdminRoomBean;
import com.feiyu.live.http.LiveHttpConsts;
import com.feiyu.live.http.LiveHttpUtil;

import java.util.Arrays;
import java.util.List;

/**
 * Created by cxf on 2019/4/23.
 * 我的房间
 */

public class LiveMyRoomViewHolder extends AbsCommonViewHolder implements OnItemClickListener<LiveAdminRoomBean> {

    private CommonRefreshView mRefreshView;
    private LiveAdminRoomAdapter mAdapter;

    public LiveMyRoomViewHolder(Context context, ViewGroup parentView) {
        super(context, parentView);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.view_live_my_room;
    }

    @Override
    public void init() {
        mRefreshView = (CommonRefreshView) findViewById(R.id.refreshView);
        mRefreshView.setEmptyLayoutId(R.layout.view_no_data_admin_room);
        mRefreshView.setLayoutManager(new LinearLayoutManager(mContext, LinearLayoutManager.VERTICAL, false));
        mRefreshView.setDataHelper(new CommonRefreshView.DataHelper<LiveAdminRoomBean>() {
            @Override
            public RefreshAdapter<LiveAdminRoomBean> getAdapter() {
                if (mAdapter == null) {
                    mAdapter = new LiveAdminRoomAdapter(mContext);
                    mAdapter.setOnItemClickListener(LiveMyRoomViewHolder.this);
                }
                return mAdapter;
            }

            @Override
            public void loadData(int p, HttpCallback callback) {
                LiveHttpUtil.getMyAdminRoomList(p, callback);
            }

            @Override
            public List<LiveAdminRoomBean> processData(String[] info) {
                return JSON.parseArray(Arrays.toString(info), LiveAdminRoomBean.class);
            }

            @Override
            public void onRefreshSuccess(List<LiveAdminRoomBean> list, int listCount) {

            }

            @Override
            public void onRefreshFailure() {

            }

            @Override
            public void onLoadMoreSuccess(List<LiveAdminRoomBean> loadItemList, int loadItemCount) {

            }

            @Override
            public void onLoadMoreFailure() {

            }
        });
    }

    @Override
    public void loadData() {
        if (isFirstLoadData()) {
            if (mRefreshView != null) {
                mRefreshView.initData();
            }
        }
    }

    @Override
    public void onDestroy() {
        LiveHttpUtil.cancel(LiveHttpConsts.GET_MY_ADMIN_ROOM_LIST);
        super.onDestroy();
    }

    @Override
    public void onItemClick(LiveAdminRoomBean bean, int position) {
        RoomManageDetailActivity.forward(mContext, bean);
    }
}
