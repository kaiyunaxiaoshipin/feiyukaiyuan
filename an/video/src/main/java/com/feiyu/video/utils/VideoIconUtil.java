package com.feiyu.video.utils;

import com.feiyu.video.R;

import java.util.Arrays;
import java.util.List;

/**
 * Created by cxf on 2018/10/11.
 */

public class VideoIconUtil {
    private static List<Integer> sVideoLikeAnim;//视频点赞动画

    static {
        sVideoLikeAnim = Arrays.asList(
                R.mipmap.icon_video_zan_02,
                R.mipmap.icon_video_zan_03,
                R.mipmap.icon_video_zan_04,
                R.mipmap.icon_video_zan_05,
                R.mipmap.icon_video_zan_06,
                R.mipmap.icon_video_zan_07,
                R.mipmap.icon_video_zan_08,
                R.mipmap.icon_video_zan_09,
                R.mipmap.icon_video_zan_10,
                R.mipmap.icon_video_zan_11,
                R.mipmap.icon_video_zan_12,
                R.mipmap.icon_video_zan_13,
                R.mipmap.icon_video_zan_14,
                R.mipmap.icon_video_zan_15
        );
    }

    public static List<Integer> getVideoLikeAnim() {
        return sVideoLikeAnim;
    }

}
