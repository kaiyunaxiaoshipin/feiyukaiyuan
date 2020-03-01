package com.feiyu.im.utils;

import android.content.Context;
import android.text.TextUtils;

import com.feiyu.common.CommonAppConfig;
import com.feiyu.common.CommonAppContext;
import com.feiyu.common.interfaces.CommonCallback;
import com.feiyu.common.utils.L;
import com.feiyu.common.utils.SpUtil;
import com.feiyu.common.utils.WordUtil;
import com.feiyu.im.R;
import com.feiyu.im.bean.ImMessageBean;
import com.feiyu.im.bean.ImMsgLocationBean;
import com.feiyu.im.bean.ImUserBean;
import com.feiyu.im.event.ImOffLineMsgEvent;
import com.feiyu.im.event.ImRoamMsgEvent;
import com.feiyu.im.event.ImUnReadCountEvent;
import com.feiyu.im.event.ImUserMsgEvent;
import com.feiyu.im.interfaces.ImClient;
import com.feiyu.im.interfaces.SendMsgResultCallback;

import org.greenrobot.eventbus.EventBus;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.jpush.im.android.api.JMessageClient;
import cn.jpush.im.android.api.callback.DownloadCompletionCallback;
import cn.jpush.im.android.api.content.ImageContent;
import cn.jpush.im.android.api.content.LocationContent;
import cn.jpush.im.android.api.content.MessageContent;
import cn.jpush.im.android.api.content.TextContent;
import cn.jpush.im.android.api.content.VoiceContent;
import cn.jpush.im.android.api.enums.MessageStatus;
import cn.jpush.im.android.api.event.ConversationRefreshEvent;
import cn.jpush.im.android.api.event.MessageEvent;
import cn.jpush.im.android.api.event.OfflineMessageEvent;
import cn.jpush.im.android.api.model.Conversation;
import cn.jpush.im.android.api.model.Message;
import cn.jpush.im.android.api.model.UserInfo;
import cn.jpush.im.android.api.options.MessageSendingOptions;
import cn.jpush.im.api.BasicCallback;

/**
 * Created by cxf on 2017/8/10.
 * 极光IM注册、登陆等功能
 */

public class JimMessageUtil implements ImClient {

    private static final String TAG = "极光IM";
    private static final String PWD_SUFFIX = "PUSH";//注册极光IM的时候，密码是用户id+"PUSH"这个常量构成的
    //前缀，当uid不够长的时候无法注册
    public static final String PREFIX = "";
    private Map<String, Long> mMap;
    //针对消息发送动作的控制选项
    private MessageSendingOptions mOptions;
    private SimpleDateFormat mSimpleDateFormat;
    private String mImageString;
    private String mVoiceString;
    private String mLocationString;
    private BasicCallback mSendCompleteCallback;
    private SendMsgResultCallback mSendMsgResultCallback;
    private BasicCallback mHasReadCallback;
    private Runnable mHasReadRunable;


    public JimMessageUtil() {
        mMap = new HashMap<>();
        mOptions = new MessageSendingOptions();
        mOptions.setShowNotification(false);//设置针对本次消息发送，是否需要在消息接收方的通知栏上展示通知
        mSimpleDateFormat = new SimpleDateFormat("MM-dd HH:mm");
        mImageString = WordUtil.getString(R.string.im_type_image);
        mVoiceString = WordUtil.getString(R.string.im_type_voide);
        mLocationString = WordUtil.getString(R.string.im_type_location);
    }


    public void init() {
        //开启消息漫游
        JMessageClient.init(CommonAppContext.sInstance, true);
    }

    /**
     * 将app中用户的uid转成IM用户的uid
     */
    private String getImUid(String uid) {
        return PREFIX + uid;
    }

    /**
     * 将IM用户的uid转成app用户的uid
     */
    private String getAppUid(String from) {
        if (!TextUtils.isEmpty(from) && from.length() > PREFIX.length()) {
            return from.substring(PREFIX.length());
        }
        return "";
    }

    /**
     * 根据极光IM conversation 获取App用户的uid
     */
    private String getAppUid(Conversation conversation) {
        if (conversation == null) {
            return "";
        }
        Object targetInfo = conversation.getTargetInfo();
        if (targetInfo == null) {
            return "";
        }
        if (targetInfo instanceof UserInfo) {
            String userName = ((UserInfo) targetInfo).getUserName();
            return getAppUid(userName);
        }
        return "";
    }


    /**
     * 根据极光IM发的消息 获取App用户的uid
     */
    private String getAppUid(Message msg) {
        if (msg == null) {
            return "";
        }
        UserInfo userInfo = msg.getFromUser();
        if (userInfo == null) {
            return "";
        }
        String userName = userInfo.getUserName();
        return getAppUid(userName);
    }


    /**
     * 登录极光IM
     */
    public void loginImClient(String uid) {
        if (SpUtil.getInstance().getBooleanValue(SpUtil.IM_LOGIN)) {
            L.e(TAG, "极光IM已经登录了");
            JMessageClient.registerEventReceiver(JimMessageUtil.this);
            CommonAppConfig.getInstance().setLoginIM(true);
            //EventBus.getDefault().post(new ImLoginEvent(true));
            refreshAllUnReadMsgCount();
            return;
        }
        final String imUid = getImUid(uid);
        JMessageClient.login(imUid, imUid + PWD_SUFFIX, new BasicCallback() {
            @Override
            public void gotResult(int code, String msg) {
                L.e(TAG, "登录极光回调---gotResult--->code: " + code + " msg: " + msg);
                if (code == 801003) {//用户不存在
                    L.e(TAG, "未注册，用户不存在");
                    registerAndLoginJMessage(imUid);
                } else if (code == 0) {
                    L.e(TAG, "极光IM登录成功");
                    SpUtil.getInstance().setBooleanValue(SpUtil.IM_LOGIN, true);
                    JMessageClient.registerEventReceiver(JimMessageUtil.this);
                    CommonAppConfig.getInstance().setLoginIM(true);
                    //EventBus.getDefault().post(new ImLoginEvent(true));
                    refreshAllUnReadMsgCount();
                }
            }
        });

    }

    //注册并登录极光IM
    private void registerAndLoginJMessage(final String uid) {
        JMessageClient.register(uid, uid + PWD_SUFFIX, new BasicCallback() {

            @Override
            public void gotResult(int code, String msg) {
                L.e(TAG, "注册极光回调---gotResult--->code: " + code + " msg: " + msg);
                if (code == 0) {
                    L.e(TAG, "极光IM注册成功");
                    loginImClient(uid);
                }
            }
        });
    }

    /**
     * 登出极光IM
     */
    public void logoutImClient() {
        JMessageClient.unRegisterEventReceiver(JimMessageUtil.this);
        JMessageClient.logout();
        //EventBus.getDefault().post(new ImLoginEvent(false));
        CommonAppConfig.getInstance().setLoginIM(false);
        L.e(TAG, "极光IM登出");
    }


    /**
     * 获取会话列表用户的uid，多个uid以逗号分隔
     */
    public String getConversationUids() {
        List<Conversation> conversationList = JMessageClient.getConversationList();
        String uids = "";
        if (conversationList != null) {
            for (Conversation conversation : conversationList) {
                Object targetInfo = conversation.getTargetInfo();
                if (targetInfo == null || !(targetInfo instanceof UserInfo)) {
                    continue;
                }
                List<Message> messages = conversation.getAllMessage();
                if (messages == null || messages.size() == 0) {
                    String userName = ((UserInfo) targetInfo).getUserName();
                    JMessageClient.deleteSingleConversation(userName);
                    continue;
                }
                String from = getAppUid(conversation);
                if (!TextUtils.isEmpty(from)) {
                    uids += from;
                    uids += ",";
                }
            }
        }
        if (uids.endsWith(",")) {
            uids = uids.substring(0, uids.length() - 1);
        }
        return uids;
    }

    /**
     * 获取会话的最后一条消息的信息
     */
    public List<ImUserBean> getLastMsgInfoList(List<ImUserBean> list) {
        if (list == null) {
            return null;
        }
        for (ImUserBean bean : list) {
            Conversation conversation = JMessageClient.getSingleConversation(getImUid(bean.getId()));
            if (conversation != null) {
                bean.setHasConversation(true);
                Message msg = conversation.getLatestMessage();
                if (msg != null) {
                    bean.setLastTime(getMessageTimeString(msg));
                    bean.setUnReadCount(conversation.getUnReadMsgCnt());
                    bean.setMsgType(getMessageType(msg));
                    bean.setLastMessage(getMessageString(msg));
                }
            } else {
                bean.setHasConversation(false);
            }
        }
        return list;
    }

    /**
     * 获取消息列表
     */
    private List<ImMessageBean> getChatMessageList(String toUid) {
        List<ImMessageBean> result = new ArrayList<>();
        Conversation conversation = JMessageClient.getSingleConversation(getImUid(toUid));
        if (conversation == null) {
            return result;
        }
        List<Message> msgList = conversation.getAllMessage();
        if (msgList == null) {
            return result;
        }
        int size = msgList.size();
        if (size < 20) {
            Message latestMessage = conversation.getLatestMessage();
            if (latestMessage == null) {
                return result;
            }
            List<Message> list = conversation.getMessagesFromNewest(latestMessage.getId(), 20 - size);
            if (list == null) {
                return result;
            }
            list.addAll(msgList);
            msgList = list;
        }
        String uid = CommonAppConfig.getInstance().getUid();
        for (Message msg : msgList) {
            String from = getAppUid(msg);
            if (TextUtils.isEmpty(from)) {
                continue;
            }
            int type = getMessageType(msg);
            if (!TextUtils.isEmpty(from) && type != 0) {
                boolean self = from.equals(uid);
                ImMessageBean bean = new ImMessageBean(from, msg, type, self);
                if (self && msg.getServerMessageId() == 0 || msg.getStatus() == MessageStatus.send_fail) {
                    bean.setSendFail(true);
                }
                result.add(bean);
            }
        }
        return result;
    }

    /**
     * 获取消息列表
     */
    @Override
    public void getChatMessageList(String toUid, CommonCallback<List<ImMessageBean>> callback) {
        if (callback != null) {
            callback.callback(getChatMessageList(toUid));
        }
    }


    /**
     * 获取某个会话的未读消息数
     */
    public int getUnReadMsgCount(String uid) {
        Conversation conversation = JMessageClient.getSingleConversation(getImUid(uid));
        if (conversation != null) {
            return conversation.getUnReadMsgCnt();
        }
        return 0;
    }

    /**
     * 刷新全部未读消息的总数
     */
    public void refreshAllUnReadMsgCount() {
        EventBus.getDefault().post(new ImUnReadCountEvent(getAllUnReadMsgCount()));
    }

    /**
     * 获取全部未读消息的总数
     */
    public String getAllUnReadMsgCount() {
        int unReadCount = JMessageClient.getAllUnReadMsgCount();
        L.e(TAG, "未读消息总数----->" + unReadCount);
        String res = "";
        if (unReadCount > 99) {
            res = "99+";
        } else {
            if (unReadCount < 0) {
                unReadCount = 0;
            }
            res = String.valueOf(unReadCount);
        }
        return res;
    }

    /**
     * 设置某个会话的消息为已读
     *
     * @param toUid 对方uid
     */
    public void markAllMessagesAsRead(String toUid, boolean needRefresh) {
        if (!TextUtils.isEmpty(toUid)) {
            Conversation conversation = JMessageClient.getSingleConversation(getImUid(toUid));
            if (conversation != null) {
                conversation.resetUnreadCount();
                if (needRefresh) {
                    refreshAllUnReadMsgCount();
                }
            }
        }
    }

    /**
     * 标记所有会话为已读  即忽略所有未读
     */
    public void markAllConversationAsRead() {
        List<Conversation> list = JMessageClient.getConversationList();
        if (list == null) {
            return;
        }
        for (Conversation conversation : list) {
            conversation.resetUnreadCount();
        }
        EventBus.getDefault().post(new ImUnReadCountEvent("0"));
    }


    /**
     * 传透消息
     * 消息透传发送的内容后台不会为其离线保存，只会在对方用户在线的前提下将内容推送给对方。
     * SDK 收到命令之后也不会本地保存，不发送通知栏通知，整体快速响应。
     */
//    public void onEvent(CommandNotificationEvent e){
//        L.e("onCommandNotificationEvent-------->"+e.getMsg());
//    }

    /**
     * 接收消息 目前是在子线程接收的
     */
    public void onEvent(MessageEvent event) {
        //收到消息
        Message msg = event.getMessage();
        if (msg == null) {
            return;
        }
        String uid = getAppUid(msg);
        if (TextUtils.isEmpty(uid)) {
            return;
        }
        int type = getMessageType(msg);
        if (type == 0) {
            return;
        }
        boolean canShow = true;
        Long lastTime = mMap.get(uid);
        long curTime = System.currentTimeMillis();
        if (lastTime != null) {
            if (curTime - lastTime < 1000) {
                //同一个人，上条消息距离这条消息间隔不到1秒，则不显示这条消息
                msg.setHaveRead(null);//设置为已读
                canShow = false;
            } else {
                mMap.put(uid, curTime);
            }
        } else {
            //说明sMap内没有保存这个人的信息，则是首次收到这人的信息，可以显示
            mMap.put(uid, curTime);
        }
        if (canShow) {
            L.e(TAG, "显示消息--->");
            EventBus.getDefault().post(new ImMessageBean(uid, msg, type, false));
            ImUserMsgEvent imUserMsgEvent = new ImUserMsgEvent();
            imUserMsgEvent.setUid(uid);
            imUserMsgEvent.setLastMessage(getMessageString(msg));
            imUserMsgEvent.setUnReadCount(getUnReadMsgCount(uid));
            imUserMsgEvent.setLastTime(getMessageTimeString(msg));
            EventBus.getDefault().post(imUserMsgEvent);
            refreshAllUnReadMsgCount();
        }
    }

    /**
     * 接收离线消息
     */
    public void onEvent(OfflineMessageEvent event) {
        String from = getAppUid(event.getConversation());
        L.e(TAG, "接收到离线消息-------->来自：" + from);
        if (!TextUtils.isEmpty(from) && !from.equals(CommonAppConfig.getInstance().getUid())) {
            List<Message> list = event.getOfflineMessageList();
            if (list != null && list.size() > 0) {
                ImUserBean bean = new ImUserBean();
                bean.setId(from);
                Message message = list.get(list.size() - 1);
                bean.setLastTime(getMessageTimeString(message));
                bean.setUnReadCount(list.size());
                bean.setMsgType(getMessageType(message));
                bean.setLastMessage(getMessageString(message));
                EventBus.getDefault().post(new ImOffLineMsgEvent(bean));
                refreshAllUnReadMsgCount();
            }
        }
    }

    /**
     * 获取消息的类型
     */
    private int getMessageType(Message msg) {
        int type = 0;
        if (msg == null) {
            return type;
        }
        MessageContent content = msg.getContent();
        if (content == null) {
            return type;
        }
        switch (content.getContentType()) {
            case text://文字
                type = ImMessageBean.TYPE_TEXT;
                break;
            case image://图片
                type = ImMessageBean.TYPE_IMAGE;
                break;
            case voice://语音
                type = ImMessageBean.TYPE_VOICE;
                break;
            case location://位置
                type = ImMessageBean.TYPE_LOCATION;
                break;
        }
        return type;
    }


    /**
     * 接收漫游消息
     */
    public void onEvent(ConversationRefreshEvent event) {
        Conversation conversation = event.getConversation();
        String from = getAppUid(conversation);
        L.e(TAG, "接收到漫游消息-------->来自：" + from);
        if (!TextUtils.isEmpty(from) && !from.equals(CommonAppConfig.getInstance().getUid())) {
            Message message = conversation.getLatestMessage();
            ImUserBean bean = new ImUserBean();
            bean.setId(from);
            bean.setLastTime(getMessageTimeString(message));
            bean.setUnReadCount(conversation.getUnReadMsgCnt());
            bean.setMsgType(getMessageType(message));
            bean.setLastMessage(getMessageString(message));
            EventBus.getDefault().post(new ImRoamMsgEvent(bean));
            refreshAllUnReadMsgCount();
        }
    }

    /**
     * 返回消息的字符串描述
     */
    private String getMessageString(Message message) {
        String result = "";
        MessageContent content = message.getContent();
        if (content == null) {
            return result;
        }
        switch (content.getContentType()) {
            case text://文字
                result = ((TextContent) content).getText();
                break;
            case image://图片
                result = mImageString;
                break;
            case voice://语音
                result = mVoiceString;
                break;
            case location://位置
                result = mLocationString;
                break;
        }
        return result;
    }

    private String getMessageTimeString(Message message) {
        return mSimpleDateFormat.format(new Date(message.getCreateTime()));
    }

    private String getMessageTimeString(long time) {
        return mSimpleDateFormat.format(new Date(time));
    }

    /**
     * 创建文本消息
     *
     * @param toUid
     * @param content
     * @return
     */
    public ImMessageBean createTextMessage(String toUid, String content) {
        Message message = JMessageClient.createSingleTextMessage(PREFIX + toUid, content);
        if (message == null) {
            return null;
        }
        return new ImMessageBean(CommonAppConfig.getInstance().getUid(), message, ImMessageBean.TYPE_TEXT, true);
    }

    /**
     * 创建图片消息
     *
     * @param toUid 对方的id
     * @param path  图片路径
     * @return
     */
    public ImMessageBean createImageMessage(String toUid, String path) {
        CommonAppConfig config = CommonAppConfig.getInstance();
        String appKey = config.getJPushAppKey();
        try {
            Message message = JMessageClient.createSingleImageMessage(PREFIX + toUid, appKey, new File(path));
            return new ImMessageBean(config.getUid(), message, ImMessageBean.TYPE_IMAGE, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取图片文件
     */
    public void displayImageFile(final Context context, final ImMessageBean bean, final CommonCallback<File> commonCallback) {
        if (bean != null && commonCallback != null) {
            Message msg = bean.getJimRawMessage();
            if (msg != null) {
                MessageContent messageContent = msg.getContent();
                if (messageContent instanceof ImageContent) {
                    final ImageContent imageContent = (ImageContent) messageContent;
                    String localPath = imageContent.getLocalPath();
                    if (!TextUtils.isEmpty(localPath)) {
                        File file = new File(localPath);
                        if (file.exists()) {
                            commonCallback.callback(file);
                            return;
                        }
                    }
                    imageContent.downloadOriginImage(msg, new DownloadCompletionCallback() {
                        @Override
                        public void onComplete(int i, String s, File file) {
//                            bean.setImageFile(file);
//                            if (imageView instanceof MyImageView) {
//                                ((MyImageView) imageView).setFile(file);
//                            }
//                            ImgLoader.display(context, file, imageView);

                            commonCallback.callback(file);

                        }
                    });
                }
            }
        }
    }

    /**
     * 获取语音文件
     */
    public void getVoiceFile(final ImMessageBean bean, final CommonCallback<File> commonCallback) {
        if (bean != null && commonCallback != null) {
            Message msg = bean.getJimRawMessage();
            if (msg != null) {
                MessageContent messageContent = msg.getContent();
                if (messageContent instanceof VoiceContent) {
                    final VoiceContent voiceContent = (VoiceContent) messageContent;
                    String localPath = voiceContent.getLocalPath();
                    if (!TextUtils.isEmpty(localPath)) {
                        File file = new File(localPath);
                        if (file.exists()) {
                            commonCallback.callback(file);
                            return;
                        }
                    }
                    voiceContent.downloadVoiceFile(msg, new DownloadCompletionCallback() {
                        @Override
                        public void onComplete(int i, String s, File file) {
                            if (file != null && file.exists()) {
                                commonCallback.callback(file);
                            }
                        }
                    });
                }
            }
        }
    }

    /**
     * 创建位置消息
     *
     * @param toUid
     * @param lat     纬度
     * @param lng     经度
     * @param scale   缩放比例
     * @param address 位置详细地址
     * @return
     */
    public ImMessageBean createLocationMessage(String toUid, double lat, double lng, int scale, String address) {
        String appKey = CommonAppConfig.getInstance().getJPushAppKey();
        Message message = JMessageClient.createSingleLocationMessage(PREFIX + toUid, appKey, lat, lng, scale, address);
        return new ImMessageBean(CommonAppConfig.getInstance().getUid(), message, ImMessageBean.TYPE_LOCATION, true);
    }

    /**
     * 创建语音消息
     *
     * @param toUid
     * @param voiceFile 语音文件
     * @param duration  语音时长
     * @return
     */
    public ImMessageBean createVoiceMessage(String toUid, File voiceFile, long duration) {
        String appKey = CommonAppConfig.getInstance().getJPushAppKey();
        try {
            Message message = JMessageClient.createSingleVoiceMessage(PREFIX + toUid, appKey, voiceFile, (int) (duration / 1000));
            return new ImMessageBean(CommonAppConfig.getInstance().getUid(), message, ImMessageBean.TYPE_VOICE, true);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 发送消息
     */
    public void sendMessage(String toUid, ImMessageBean bean, SendMsgResultCallback callback) {
        Message msg = bean.getJimRawMessage();
        if (msg == null) {
            return;
        }
        mSendMsgResultCallback = callback;
        if (mSendCompleteCallback == null) {
            mSendCompleteCallback = new BasicCallback() {
                @Override
                public void gotResult(int i, String s) {
                    if (mSendMsgResultCallback != null) {
                        mSendMsgResultCallback.onSendFinish(i == 0);
                    }
                    mSendMsgResultCallback = null;
                }
            };
        }
        msg.setOnSendCompleteCallback(mSendCompleteCallback);
        JMessageClient.sendMessage(msg, mOptions);
    }


    /**
     * 删除消息
     *
     * @param toUid
     * @param bean
     */
    @Override
    public void removeMessage(String toUid, ImMessageBean bean) {
        if (!TextUtils.isEmpty(toUid) && bean != null) {
            Message message = bean.getJimRawMessage();
            if (message != null) {
                Conversation conversation = JMessageClient.getSingleConversation(getImUid(toUid));
                if (conversation != null) {
                    conversation.deleteMessage(message.getId());
                }
            }
        }
    }

    /**
     * 删除会话中的所有消息，但不会删除会话本身。
     */
    public void removeAllMessage(String toUid) {
        if (!TextUtils.isEmpty(toUid)) {
            Conversation conversation = JMessageClient.getSingleConversation(getImUid(toUid));
            if (conversation != null) {
                conversation.deleteAllMessage();
            }
        }
    }

    /**
     * 删除会话记录
     */
    public void removeConversation(String uid) {
        JMessageClient.deleteSingleConversation(getImUid(uid));
        refreshAllUnReadMsgCount();
    }

    /**
     * 删除所有会话记录
     */
    public void removeAllConversation() {
        List<Conversation> list = JMessageClient.getConversationList();
        for (Conversation conversation : list) {
            Object targetInfo = conversation.getTargetInfo();
            JMessageClient.deleteSingleConversation(((UserInfo) targetInfo).getUserName());
        }
    }


    /**
     * 刷新聊天列表的最后一条消息
     */
    public void refreshLastMessage(String uid, ImMessageBean bean) {
        if (TextUtils.isEmpty(uid)) {
            return;
        }
        if (bean == null) {
            return;
        }
        Message msg = bean.getJimRawMessage();
        if (msg == null) {
            return;
        }
        ImUserMsgEvent imUserMsgEvent = new ImUserMsgEvent();
        imUserMsgEvent.setUid(uid);
        imUserMsgEvent.setLastMessage(getMessageString(msg));
        imUserMsgEvent.setUnReadCount(getUnReadMsgCount(uid));
        imUserMsgEvent.setLastTime(getMessageTimeString(msg));
        EventBus.getDefault().post(imUserMsgEvent);
    }

    @Override
    public void setVoiceMsgHasRead(ImMessageBean bean, Runnable runnable) {
        if (bean == null || runnable == null) {
            return;
        }
        mHasReadRunable = runnable;
        if (mHasReadCallback == null) {
            mHasReadCallback = new BasicCallback() {
                @Override
                public void gotResult(int i, String s) {
                    if (mHasReadRunable != null) {
                        mHasReadRunable.run();
                    }
                }
            };
        }
        Message message = bean.getJimRawMessage();
        if (message != null) {
            message.setHaveRead(mHasReadCallback);
        }
    }

    @Override
    public String getMessageText(ImMessageBean bean) {
        if (bean != null) {
            Message message = bean.getJimRawMessage();
            if (message != null) {
                MessageContent msgContent = message.getContent();
                if (msgContent != null && msgContent instanceof TextContent) {
                    return ((TextContent) msgContent).getText();
                }
            }
        }
        return "";
    }

    @Override
    public ImMsgLocationBean getMessageLocation(ImMessageBean bean) {
        if (bean != null) {
            Message message = bean.getJimRawMessage();
            if (message != null) {
                MessageContent msgContent = message.getContent();
                if (msgContent != null && msgContent instanceof LocationContent) {
                    LocationContent locationContent = (LocationContent) msgContent;
                    return new ImMsgLocationBean(locationContent.getAddress(),
                            locationContent.getScale().intValue(),
                            locationContent.getLatitude().doubleValue(),
                            locationContent.getLongitude().doubleValue());
                }
            }
        }
        return null;
    }

}
