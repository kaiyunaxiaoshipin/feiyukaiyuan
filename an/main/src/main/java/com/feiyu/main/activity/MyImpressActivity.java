package com.feiyu.main.activity;

import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.feiyu.common.activity.AbsActivity;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.bean.ImpressBean;
import com.feiyu.live.custom.MyTextView;
import com.feiyu.main.R;
import com.feiyu.main.http.MainHttpConsts;
import com.feiyu.main.http.MainHttpUtil;

import java.util.Arrays;
import java.util.List;

/**
 * Created by cxf on 2018/10/15.
 * 我收到的主播印象
 */

public class MyImpressActivity extends AbsActivity {

    private LinearLayout mGroup;
    private TextView mTip;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_my_impress;
    }

    @Override
    protected void main() {
        setTitle(WordUtil.getString(R.string.impress));
        mGroup = (LinearLayout) findViewById(R.id.group);
        mTip = (TextView) findViewById(R.id.tip);
        MainHttpUtil.getMyImpress(new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0) {
                    if (info.length > 0) {
                        List<ImpressBean> list = JSON.parseArray(Arrays.toString(info), ImpressBean.class);
                        int line = 0;
                        int fromIndex = 0;
                        boolean hasNext = true;
                        LayoutInflater inflater = LayoutInflater.from(mContext);
                        while (hasNext) {
                            LinearLayout linearLayout = (LinearLayout) inflater.inflate(R.layout.view_impress_line, mGroup, false);
                            int endIndex = line % 2 == 0 ? fromIndex + 3 : fromIndex + 2;
                            if (endIndex >= list.size()) {
                                endIndex = list.size();
                                hasNext = false;
                            }
                            for (int i = fromIndex; i < endIndex; i++) {
                                MyTextView item = (MyTextView) inflater.inflate(R.layout.view_impress_item, linearLayout, false);
                                item.setBean(list.get(i),true);
                                linearLayout.addView(item);
                            }
                            fromIndex = endIndex;
                            line++;
                            mGroup.addView(linearLayout);
                        }
                    } else {
                        mTip.setText(WordUtil.getString(R.string.impress_tip_3));
                    }
                }
            }
        });
    }

    @Override
    protected void onDestroy() {
        MainHttpUtil.cancel(MainHttpConsts.GET_MY_IMPRESS);
        super.onDestroy();
    }
}
