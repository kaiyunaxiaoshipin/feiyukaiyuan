package com.feiyu.main.activity;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.widget.Toast;

public class QQUtil {
    public static void toQQServer(Context context){
        try {
            ApplicationInfo info = context.getPackageManager().getApplicationInfo("com.tencent.mobileqq",
                    PackageManager.GET_UNINSTALLED_PACKAGES);
            if (info!=null){
                context.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin=24361300&version=1")));
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            Toast.makeText(context,"您还未安装QQ应用",Toast.LENGTH_SHORT).show();
        }
    }
}