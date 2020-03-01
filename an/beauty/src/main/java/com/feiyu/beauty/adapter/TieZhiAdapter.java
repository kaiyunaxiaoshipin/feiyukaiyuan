package com.feiyu.beauty.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.feiyu.beauty.bean.TieZhiBean;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.Constants;
import com.feiyu.beauty.R;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.CommonHttpUtil;
import com.feiyu.common.interfaces.OnItemClickListener;
import com.feiyu.common.utils.DownloadUtil;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;

import java.io.File;
import java.util.List;

import cn.tillusory.sdk.TiSDK;
import cn.tillusory.sdk.common.TiUtils;


/**
 * Created by cxf on 2018/6/23.
 * 萌颜 贴纸
 */

public class TieZhiAdapter extends RecyclerView.Adapter<TieZhiAdapter.Vh> {

    private Context mContext;
    private List<TieZhiBean> mList;
    private LayoutInflater mInflater;
    private Drawable mCheckDrawable;
    private int mCheckedPosition;
    private OnItemClickListener<TieZhiBean> mOnItemClickListener;
    private static final int MAX_DOWNLOAD_TASK = 3;
    private SparseArray<String> mLoadingTaskMap;
    private DownloadUtil mDownloadUtil;
    private View.OnClickListener mOnClickListener;


    public TieZhiAdapter(Context context) {
        mContext = context;
        mList = TieZhiBean.getTieZhiList(context);
        mInflater = LayoutInflater.from(context);
        mCheckDrawable = ContextCompat.getDrawable(context, R.drawable.bg_item_tiezhi);
        mLoadingTaskMap = new SparseArray<>();
        mDownloadUtil = new DownloadUtil();
        mOnClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Object tag = v.getTag();
                if (tag == null) {
                    return;
                }
                final int position = (int) tag;
                if (position < 0 || position >= mList.size()) {
                    return;
                }
                final TieZhiBean bean = mList.get(position);
                if (bean == null) {
                    return;
                }
                if (!bean.isDownloaded()) {
                    if (mDownloadUtil != null && mLoadingTaskMap.size() < MAX_DOWNLOAD_TASK &&
                            mLoadingTaskMap.indexOfKey(position) < 0) {//不存在这个key
                        String name = bean.getName();
                        mLoadingTaskMap.put(position, name);
                        bean.setDownloading(true);
                        notifyItemChanged(position, Constants.PAYLOAD);
                        mDownloadUtil.download(name, CommonAppConfig.VIDEO_TIE_ZHI_PATH, name, bean.getUrl(), new DownloadUtil.Callback() {
                            @Override
                            public void onSuccess(File file) {
                                if (file != null) {
                                    File targetDir = new File(TiSDK.getStickerPath(mContext));
                                    try {
                                        //解压到贴纸目录
                                        TiUtils.unzip(file, targetDir);
                                        bean.setDownloadSuccess(mContext);
                                    } catch (Exception e) {
                                        ToastUtil.show(WordUtil.getString(R.string.tiezhi_download_failed));
                                        bean.setDownloading(false);
                                    } finally {
                                        file.delete();
                                        notifyItemChanged(position, Constants.PAYLOAD);
                                        mLoadingTaskMap.remove(position);
                                    }
                                }
                            }

                            @Override
                            public void onProgress(int progress) {

                            }

                            @Override
                            public void onError(Throwable e) {
                                ToastUtil.show(WordUtil.getString(R.string.tiezhi_download_failed));
                                bean.setDownloading(false);
                                notifyItemChanged(position, Constants.PAYLOAD);
                                mLoadingTaskMap.remove(position);
                            }
                        });
                    }
                } else {
                    if (mCheckedPosition != position) {
                        if (mCheckedPosition >= 0 && mCheckedPosition < mList.size()) {
                            mList.get(mCheckedPosition).setChecked(false);
                        }
                        mList.get(position).setChecked(true);
                        notifyItemChanged(mCheckedPosition, Constants.PAYLOAD);
                        notifyItemChanged(position, Constants.PAYLOAD);
                        mCheckedPosition = position;
                        if (mOnItemClickListener != null) {
                            mOnItemClickListener.onItemClick(bean, position);
                        }
                    }
                }
            }
        };
    }


    public void setOnItemClickListener(OnItemClickListener<TieZhiBean> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    @Override
    public Vh onCreateViewHolder(ViewGroup parent, int viewType) {
        return new Vh(mInflater.inflate(R.layout.item_list_tiezhi, parent, false));
    }

    @Override
    public void onBindViewHolder(Vh holder, int position) {

    }

    @Override
    public void onBindViewHolder(Vh vh, int position, List<Object> payloads) {
        Object payload = payloads.size() > 0 ? payloads.get(0) : null;
        vh.setData(mList.get(position), position, payload);
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    class Vh extends RecyclerView.ViewHolder {

        ImageView mImg;
        View mLoading;
        View mDownLoad;

        public Vh(View itemView) {
            super(itemView);
            mImg = (ImageView) itemView.findViewById(R.id.img);
            mLoading = itemView.findViewById(R.id.loading);
            mDownLoad = itemView.findViewById(R.id.download);
            itemView.setOnClickListener(mOnClickListener);
        }

        void setData(TieZhiBean bean, int position, Object payload) {
            itemView.setTag(position);
            if (payload == null) {
                if (position == 0) {
                    mImg.setImageResource(R.mipmap.icon_tiezhi_none);
                } else {
                    ImgLoader.display(mContext,bean.getThumb(), mImg);
                }
            }
            if (bean.isDownloading()) {
                if (mLoading.getVisibility() != View.VISIBLE) {
                    mLoading.setVisibility(View.VISIBLE);
                }
            } else {
                if (mLoading.getVisibility() == View.VISIBLE) {
                    mLoading.setVisibility(View.INVISIBLE);
                }
            }
            if (bean.isDownloaded()) {
                if (mDownLoad.getVisibility() == View.VISIBLE) {
                    mDownLoad.setVisibility(View.INVISIBLE);
                }
            } else {
                if (mDownLoad.getVisibility() != View.VISIBLE) {
                    mDownLoad.setVisibility(View.VISIBLE);
                }
            }
            if (bean.isChecked()) {
                itemView.setBackground(mCheckDrawable);
            } else {
                itemView.setBackground(null);
            }
        }
    }


    public void clear() {
        if (mLoadingTaskMap != null) {
            for (int i = 0, size = mLoadingTaskMap.size(); i < size; i++) {
                String tag = mLoadingTaskMap.valueAt(i);
                CommonHttpUtil.cancel(tag);
            }
        }
    }
}
