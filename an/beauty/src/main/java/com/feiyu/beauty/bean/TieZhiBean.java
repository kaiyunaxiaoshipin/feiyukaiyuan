package com.feiyu.beauty.bean;

import android.content.Context;

import java.util.ArrayList;
import java.util.List;

import cn.tillusory.sdk.bean.TiSticker;

/**
 * Created by cxf on 2018/6/23.
 */

public class TieZhiBean {

    private TiSticker tiSticker;
    private boolean checked;
    private boolean downloading;


    public TieZhiBean(TiSticker tiSticker) {
        this.tiSticker = tiSticker;
    }

    public TieZhiBean(TiSticker tiSticker, boolean checked) {
        this.tiSticker = tiSticker;
        this.checked = checked;
    }

    public String getUrl() {
        if (this.tiSticker != null) {
            return this.tiSticker.getUrl();
        }
        return null;
    }

    public String getName() {
        if (this.tiSticker != null) {
            return this.tiSticker.getName();
        }
        return null;
    }

    public String getThumb() {
        if (this.tiSticker != null) {
            return this.tiSticker.getThumb();
        }
        return null;
    }

    public boolean isDownloaded() {
        if (this.tiSticker != null) {
            return this.tiSticker.isDownloaded();
        }
        return false;
    }

    public void setDownloadSuccess(Context context) {
        if (this.tiSticker != null) {
            this.tiSticker.setDownloaded(true);
            this.tiSticker.stickerDownload(context);
        }
        downloading=false;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public boolean isDownloading() {
        return downloading;
    }

    public void setDownloading(boolean downloading) {
        this.downloading = downloading;
    }

    /**
     * 获取贴纸列表
     */
    public static List<TieZhiBean> getTieZhiList(Context context) {
        List<TieZhiBean> result = new ArrayList<>();
        result.add(new TieZhiBean(TiSticker.NO_STICKER, true));
        List<TiSticker> list = TiSticker.getAllStickers(context);
        for (TiSticker tiSticker : list) {
            result.add(new TieZhiBean(tiSticker));
        }
        return result;
    }
}
