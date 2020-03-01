package com.feiyu.live.dialog;

import android.Manifest;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import com.feiyu.common.Constants;
import com.feiyu.common.bean.UserBean;
import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.interfaces.ActivityResultCallback;
import com.feiyu.common.interfaces.ImageResultCallback;
import com.feiyu.common.utils.DpUtil;
import com.feiyu.common.utils.ProcessImageUtil;
import com.feiyu.common.utils.ToastUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.im.activity.ChatChooseImageActivity;
import com.feiyu.im.activity.LocationActivity;
import com.feiyu.im.interfaces.ChatRoomActionListener;
import com.feiyu.im.views.ChatRoomDialogViewHolder;
import com.feiyu.live.R;
import com.feiyu.live.activity.LiveActivity;

import java.io.File;

/**
 * Created by cxf on 2018/10/24.
 * 直播间私信聊天窗口
 */

public class LiveChatRoomDialogFragment extends AbsDialogFragment {

    private ChatRoomDialogViewHolder mChatRoomViewHolder;
    private int mOriginHeight;
    private ProcessImageUtil mImageUtil;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_chat_room;
    }

    @Override
    protected int getDialogStyle() {
        return R.style.dialog2;
    }

    @Override
    protected boolean canCancel() {
        return true;
    }

    @Override
    protected void setWindowAttributes(Window window) {
        window.setWindowAnimations(R.style.leftToRightAnim);
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        mOriginHeight = DpUtil.dp2px(300);
        params.height = mOriginHeight;
        params.gravity = Gravity.BOTTOM;
        window.setAttributes(params);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        ((LiveActivity) mContext).setChatRoomOpened(this, true);
        Bundle bundle = getArguments();
        if (bundle == null) {
            return;
        }
        UserBean userBean = bundle.getParcelable(Constants.USER_BEAN);
        if (userBean == null) {
            return;
        }
        boolean following = bundle.getBoolean(Constants.FOLLOW);
        mChatRoomViewHolder = new ChatRoomDialogViewHolder(mContext, (ViewGroup) mRootView.findViewById(R.id.container), userBean, following);
        mChatRoomViewHolder.setActionListener(new ChatRoomActionListener() {
            @Override
            public void onCloseClick() {
                dismiss();
            }

            @Override
            public void onPopupWindowChanged(int deltaHeight) {
                addHeight(deltaHeight);
            }

            @Override
            public void onChooseImageClick() {
                checkReadWritePermissions();
            }

            @Override
            public void onCameraClick() {
                takePhoto();
            }

            @Override
            public void onVoiceInputClick() {
                checkVoiceRecordPermission(new Runnable() {
                    @Override
                    public void run() {
                        openVoiceInputDialog();
                    }
                });
            }

            @Override
            public void onLocationClick() {
                checkLocationPermission();
            }

            @Override
            public void onVoiceClick() {
                checkVoiceRecordPermission(new Runnable() {
                    @Override
                    public void run() {
                        if (mChatRoomViewHolder != null) {
                            mChatRoomViewHolder.clickVoiceRecord();
                        }
                    }
                });
            }

            @Override
            public ViewGroup getImageParentView() {
                return ((LiveActivity) mContext).getPageContainer();
            }

        });
        mChatRoomViewHolder.addToParent();
        mChatRoomViewHolder.loadData();
    }


    public void setImageUtil(ProcessImageUtil imageUtil) {
        mImageUtil = imageUtil;
        mImageUtil.setImageResultCallback(new ImageResultCallback() {
            @Override
            public void beforeCamera() {

            }

            @Override
            public void onSuccess(File file) {
                if (mChatRoomViewHolder != null) {
                    mChatRoomViewHolder.sendImage(file.getAbsolutePath());
                }
            }

            @Override
            public void onFailure() {

            }
        });
    }

    @Override
    public void onDestroy() {
        if (mImageUtil != null) {
            mImageUtil.setImageResultCallback(null);
        }
        mImageUtil = null;
        ((LiveActivity) mContext).setChatRoomOpened(null, false);
        if (mChatRoomViewHolder != null) {
            mChatRoomViewHolder.refreshLastMessage();
            mChatRoomViewHolder.release();
        }
        super.onDestroy();
    }

    /**
     * 增加高度
     */
    private void addHeight(int deltaHeight) {
        Window window = getDialog().getWindow();
        if (window == null) {
            return;
        }
        WindowManager.LayoutParams params = window.getAttributes();
        params.height = mOriginHeight + deltaHeight;
        window.setAttributes(params);
        if (deltaHeight > 0) {
            scrollToBottom();
        }
    }


    public void scrollToBottom() {
        if (mChatRoomViewHolder != null) {
            mChatRoomViewHolder.scrollToBottom();
        }
    }

    /**
     * 聊天时候选择图片，检查读写权限
     */
    private void checkReadWritePermissions() {
        if (mImageUtil == null) {
            return;
        }
        mImageUtil.requestPermissions(
                new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE},
                new Runnable() {
                    @Override
                    public void run() {
                        forwardChooseImage();
                    }
                });
    }


    /**
     * 前往选择图片页面
     */
    private void forwardChooseImage() {
        if (mImageUtil == null) {
            return;
        }
        mImageUtil.startActivityForResult(new Intent(mContext, ChatChooseImageActivity.class), new ActivityResultCallback() {
            @Override
            public void onSuccess(Intent intent) {
                if (intent != null) {
                    String imagePath = intent.getStringExtra(Constants.SELECT_IMAGE_PATH);
                    if (mChatRoomViewHolder != null) {
                        mChatRoomViewHolder.sendImage(imagePath);
                    }
                }
            }
        });
    }

    /**
     * 拍照
     */
    private void takePhoto() {
        if (mImageUtil != null) {
            mImageUtil.getImageByCamera(false);
        }
    }

    /**
     * 发送位置的时候检查定位权限
     */
    private void checkLocationPermission() {
        if (mImageUtil == null) {
            return;
        }
        mImageUtil.requestPermissions(
                new String[]{Manifest.permission.ACCESS_COARSE_LOCATION},
                new Runnable() {
                    @Override
                    public void run() {
                        forwardLocation();
                    }
                });
    }

    /**
     * 前往发送位置页面
     */
    private void forwardLocation() {
        if (mImageUtil == null) {
            return;
        }
        mImageUtil.startActivityForResult(new Intent(mContext, LocationActivity.class), new ActivityResultCallback() {
            @Override
            public void onSuccess(Intent intent) {
                if (intent != null) {
                    double lat = intent.getDoubleExtra(Constants.LAT, 0);
                    double lng = intent.getDoubleExtra(Constants.LNG, 0);
                    int scale = intent.getIntExtra(Constants.SCALE, 0);
                    String address = intent.getStringExtra(Constants.ADDRESS);
                    if (lat > 0 && lng > 0 && scale > 0 && !TextUtils.isEmpty(address)) {
                        if (mChatRoomViewHolder != null) {
                            mChatRoomViewHolder.sendLocation(lat, lng, scale, address);
                        }
                    } else {
                        ToastUtil.show(WordUtil.getString(R.string.im_get_location_failed));
                    }
                }
            }
        });
    }

    /**
     * 检查录音权限
     */
    private void checkVoiceRecordPermission(Runnable runnable) {
        if (mImageUtil == null) {
            return;
        }
        mImageUtil.requestPermissions(
                new String[]{
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.RECORD_AUDIO},
                runnable);
    }

    /**
     * 打开语音输入窗口
     */
    private void openVoiceInputDialog() {
//        ChatVoiceInputDialog fragment = new ChatVoiceInputDialog();
//        fragment.setChatRoomViewHolder(mChatRoomViewHolder);
//        fragment.show(((LiveActivity) mContext).getSupportFragmentManager(), "ChatVoiceInputDialog");
    }

    @Override
    public void onPause() {
        super.onPause();
        if (mChatRoomViewHolder != null) {
            mChatRoomViewHolder.onPause();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mChatRoomViewHolder != null) {
            mChatRoomViewHolder.onResume();
        }
    }
}
