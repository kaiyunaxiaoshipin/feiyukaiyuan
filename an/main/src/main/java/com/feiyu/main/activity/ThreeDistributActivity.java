package com.feiyu.main.activity;

import android.Manifest;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.support.annotation.RequiresApi;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.Constants;
import com.feiyu.common.activity.AbsActivity;
import com.feiyu.common.bean.UserBean;
import com.feiyu.common.glide.ImgLoader;
import com.feiyu.common.http.HttpCallback;
import com.feiyu.common.mob.MobShareUtil;
import com.feiyu.common.utils.BitmapUtil;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.ProcessResultUtil;
import com.feiyu.common.utils.StringUtil;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.live.dialog.LiveShareDialogFragment;
import com.feiyu.main.R;
import com.feiyu.main.http.MainHttpConsts;
import com.feiyu.main.http.MainHttpUtil;

import java.io.File;

/**
 * Created by cxf on 2019/4/29.
 * 三级分销
 */

public class ThreeDistributActivity extends AbsActivity implements View.OnClickListener, LiveShareDialogFragment.ActionListener {

    private ProgressBar mProgressBar;
    private WebView mWebView;
    private final int CHOOSE = 100;//Android 5.0以下的
    private final int CHOOSE_ANDROID_5 = 200;//Android 5.0以上的
    private ValueCallback<Uri> mValueCallback;
    private ValueCallback<Uri[]> mValueCallback2;
    private TextView mInviteCode;//邀请码
    private View mContainer;
    private ImageView mQrCode;//二维码
    private File mShareImageFile;//分享图片文件
    private ProcessResultUtil mProcessResultUtil;
    private MobShareUtil mMobShareUtil;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_three_distribut;
    }

    @Override
    protected void main() {
        mProcessResultUtil = new ProcessResultUtil(this);
        Intent intent = getIntent();
        setTitle(intent.getStringExtra(Constants.TIP));
        mContainer = findViewById(R.id.share_container);
        ImageView mAppIcon = findViewById(R.id.app_icon);
        TextView mAppName = findViewById(R.id.app_name);
        CommonAppConfig appConfig = CommonAppConfig.getInstance();
        mAppIcon.setImageResource(appConfig.getAppIconRes());
        mAppName.setText(appConfig.getAppName());
        ImageView avatar = findViewById(R.id.avatar);
        TextView name = findViewById(R.id.name);
        TextView idVal = findViewById(R.id.id_val);
        ImageView avatar2 = findViewById(R.id.avatar_2);
        mInviteCode = findViewById(R.id.invite_code);
        mQrCode = findViewById(R.id.qr_code);
        findViewById(R.id.btn_share).setOnClickListener(this);
        UserBean u = appConfig.getUserBean();
        if (u != null) {
            ImgLoader.displayAvatar(mContext, u.getAvatar(), avatar);
            ImgLoader.displayAvatar(mContext, u.getAvatar(), avatar2);
            name.setText(u.getUserNiceName());
            idVal.setText(StringUtil.contact("ID:", u.getId()));
        }


        String url = intent.getStringExtra(Constants.URL);
        L.e("H5--->" + url);
        LinearLayout container = (LinearLayout) findViewById(R.id.container);
        mProgressBar = (ProgressBar) findViewById(R.id.progressbar);
        mWebView = new WebView(mContext);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        params.topMargin = DpUtil.dp2px(1);
        mWebView.setLayoutParams(params);
        mWebView.setOverScrollMode(View.OVER_SCROLL_NEVER);
        container.addView(mWebView);
        mWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                L.e("H5-------->" + url);
                if (url.startsWith(Constants.COPY_PREFIX)) {
                    String content = url.substring(Constants.COPY_PREFIX.length());
                    if (!TextUtils.isEmpty(content)) {
                        copy(content);
                    }
                } else {
                    view.loadUrl(url);
                }
                return true;
            }

        });
        mWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                if (newProgress == 100) {
                    mProgressBar.setVisibility(View.GONE);
                } else {
                    mProgressBar.setProgress(newProgress);
                }
            }

            //以下是在各个Android版本中 WebView调用文件选择器的方法
            // For Android < 3.0
            public void openFileChooser(ValueCallback<Uri> valueCallback) {
                openImageChooserActivity(valueCallback);
            }

            // For Android  >= 3.0
            public void openFileChooser(ValueCallback valueCallback, String acceptType) {
                openImageChooserActivity(valueCallback);
            }

            //For Android  >= 4.1
            public void openFileChooser(ValueCallback<Uri> valueCallback,
                                        String acceptType, String capture) {
                openImageChooserActivity(valueCallback);
            }

            // For Android >= 5.0
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public boolean onShowFileChooser(WebView webView,
                                             ValueCallback<Uri[]> filePathCallback,
                                             FileChooserParams fileChooserParams) {
                mValueCallback2 = filePathCallback;
                Intent intent = fileChooserParams.createIntent();
                startActivityForResult(intent, CHOOSE_ANDROID_5);
                return true;
            }

        });
        mWebView.getSettings().setJavaScriptEnabled(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mWebView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
        mWebView.loadUrl(url);

        MainHttpUtil.getQrCode(new HttpCallback() {
            @Override
            public void onSuccess(int code, String msg, String[] info) {
                if (code == 0 && info.length > 0) {
                    JSONObject obj = JSON.parseObject(info[0]);
                    if (mInviteCode != null) {
                        mInviteCode.setText(obj.getString("code"));
                    }
                    if (mQrCode != null) {
                        ImgLoader.display(mContext, obj.getString("qr"), mQrCode);
                    }
                }
            }
        });

    }

    private void openImageChooserActivity(ValueCallback<Uri> valueCallback) {
        mValueCallback = valueCallback;
        Intent intent = new Intent();
        if (Build.VERSION.SDK_INT < 19) {
            intent.setAction(Intent.ACTION_GET_CONTENT);
        } else {
            intent.setAction(Intent.ACTION_PICK);
            intent.setData(MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        }
        intent.setType("image/*");
        startActivityForResult(Intent.createChooser(intent, WordUtil.getString(com.feiyu.common.R.string.choose_flie)), CHOOSE);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        switch (requestCode) {
            case CHOOSE://5.0以下选择图片后的回调
                processResult(resultCode, intent);
                break;
            case CHOOSE_ANDROID_5://5.0以上选择图片后的回调
                processResultAndroid5(resultCode, intent);
                break;
        }
    }

    private void processResult(int resultCode, Intent intent) {
        if (mValueCallback == null) {
            return;
        }
        if (resultCode == RESULT_OK && intent != null) {
            Uri result = intent.getData();
            mValueCallback.onReceiveValue(result);
        } else {
            mValueCallback.onReceiveValue(null);
        }
        mValueCallback = null;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void processResultAndroid5(int resultCode, Intent intent) {
        if (mValueCallback2 == null) {
            return;
        }
        if (resultCode == RESULT_OK && intent != null) {
            mValueCallback2.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, intent));
        } else {
            mValueCallback2.onReceiveValue(null);
        }
        mValueCallback2 = null;
    }

    protected boolean canGoBack() {
        return mWebView != null && mWebView.canGoBack();
    }

    @Override
    public void onBackPressed() {
        if (isNeedExitActivity()) {
            finish();
        } else {
            if (canGoBack()) {
                mWebView.goBack();
            } else {
                finish();
            }
        }
    }


    private boolean isNeedExitActivity() {
        if (mWebView != null) {
            String url = mWebView.getUrl();
            if (!TextUtils.isEmpty(url)) {
                return url.contains("g=Appapi&m=Auth&a=success")//身份认证成功页面
                        || url.contains("g=Appapi&m=Family&a=home");//家族申请提交成功页面

            }
        }
        return false;
    }


    public static void forward(Context context, String title, String url) {
        url += "&uid=" + CommonAppConfig.getInstance().getUid() + "&token=" + CommonAppConfig.getInstance().getToken();
        Intent intent = new Intent(context, ThreeDistributActivity.class);
        intent.putExtra(Constants.URL, url);
        intent.putExtra(Constants.TIP, title);
        context.startActivity(intent);
    }

    @Override
    protected void onDestroy() {
        if (mProcessResultUtil != null) {
            mProcessResultUtil.release();
        }
        mProcessResultUtil = null;
        MainHttpUtil.cancel(MainHttpConsts.GET_QR_CODE);
        if (mWebView != null) {
            ViewGroup parent = (ViewGroup) mWebView.getParent();
            if (parent != null) {
                parent.removeView(mWebView);
            }
            mWebView.destroy();
        }
        super.onDestroy();
    }

    /**
     * 复制到剪贴板
     */
    private void copy(String content) {
        ClipboardManager cm = (ClipboardManager) getSystemService(CLIPBOARD_SERVICE);
        ClipData clipData = ClipData.newPlainText("text", content);
        cm.setPrimaryClip(clipData);
        ToastUtil.show(getString(com.feiyu.common.R.string.copy_success));
    }

    /**
     * 生成分享图片
     */
    private void saveBitmapFile() {
        mProcessResultUtil.requestPermissions(new String[]{
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
        }, new Runnable() {
            @Override
            public void run() {
                if (mContainer == null) {
                    return;
                }
                mContainer.setDrawingCacheEnabled(true);
                Bitmap bitmap = mContainer.getDrawingCache();
                bitmap = Bitmap.createBitmap(bitmap);
                mContainer.setDrawingCacheEnabled(false);
                File dir = new File(CommonAppConfig.CAMERA_IMAGE_PATH);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                mShareImageFile = new File(dir, Constants.SHARE_QR_CODE_FILE);
                boolean result = BitmapUtil.getInstance().saveBitmap(bitmap, mShareImageFile);
                if (result) {
                    if (bitmap != null && !bitmap.isRecycled()) {
                        bitmap.recycle();
                    }
                    LiveShareDialogFragment fragment = new LiveShareDialogFragment();
                    fragment.setActionListener(ThreeDistributActivity.this);
                    fragment.show(getSupportFragmentManager(), "LiveShareDialogFragment");
                }
            }
        });

    }


    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_share) {
            saveBitmapFile();
        }
    }

    @Override
    public void onItemClick(String type) {
        if (mShareImageFile == null) {
            return;
        }
        if (mMobShareUtil == null) {
            mMobShareUtil = new MobShareUtil();
        }
        mMobShareUtil.shareImage(mContext,type, mShareImageFile.getPath(), null);
    }
}
