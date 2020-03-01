package com.feiyu.common.bean;

/**
 * Created by cxf on 2018/9/28.
 * 我的 页面的item
 */

public class UserItemBean {

    private int id;
    private String name;
    private String thumb;
    private String href;
    private boolean mGroupLast;
    private boolean mAllLast;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public boolean isGroupLast() {
        return mGroupLast;
    }

    public void setGroupLast(boolean groupLast) {
        mGroupLast = groupLast;
    }

    public boolean isAllLast() {
        return mAllLast;
    }

    public void setAllLast(boolean allLast) {
        mAllLast = allLast;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        UserItemBean bean = (UserItemBean) o;

        if (id != bean.id) return false;
        if (name != null ? !name.equals(bean.name) : bean.name != null) return false;
        if (thumb != null ? !thumb.equals(bean.thumb) : bean.thumb != null) return false;
        return href != null ? href.equals(bean.href) : bean.href == null;

    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (name != null ? name.hashCode() : 0);
        result = 31 * result + (thumb != null ? thumb.hashCode() : 0);
        result = 31 * result + (href != null ? href.hashCode() : 0);
        return result;
    }
}
