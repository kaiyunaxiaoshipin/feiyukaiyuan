#import "common.h"
NSString *const  share_title = @"share_title";
NSString *const  share_des = @"share_des";
NSString *const  wx_siteurl = @"wx_siteurl";
NSString *const  ipa_ver = @"ipa_ver";
NSString *const  app_ios = @"app_ios";
NSString *const  ios_shelves = @"ios_shelves";
NSString *const  name_coin = @"name_coin";
NSString *const  name_votes = @"name_votes";
NSString *const  enter_tip_level = @"enter_tip_level";

NSString *const  maintain_switch = @"maintain_switch";
NSString *const  maintain_tips = @"maintain_tips";
NSString *const  live_cha_switch = @"live_cha_switch";
NSString *const  live_pri_switch = @"live_pri_switch";
NSString *const  live_time_coin = @"live_time_coin";
NSString *const  live_time_switch = @"live_time_switch";
NSString *const  live_type = @"live_type";
NSString *const  share_type = @"share_type";


NSString *const  agorakitid = @"agorakitid";

NSString *const  personc = @"personc";
NSString *const  liveclass = @"liveclass";

NSString *const  levelUser = @"levelUser";
NSString *const  levelanchor = @"levelanchor";

NSString *const  sprout_key = @"sprout_key";
NSString *const  sprout_white = @"sprout_white";
NSString *const  sprout_skin = @"sprout_skin";
NSString *const  sprout_saturated = @"sprout_saturated";
NSString *const  sprout_pink = @"sprout_pink";
NSString *const  sprout_eye = @"sprout_eye";
NSString *const  sprout_face = @"sprout_face";
NSString *const  jpush_sys_roomid = @"jpush_sys_roomid";
NSString *const  qiniu_domain = @"qiniu_domain";
NSString *const  video_share_title = @"video_share_title";
NSString *const  video_share_des = @"video_share_des";

NSString *const  video_audit_switch = @"video_audit_switch";
NSString *const  tximgfolder = @"tximgfolder";
NSString *const  txvideofolder = @"txvideofolder";
NSString *const  cloudtype = @"cloudtype";

@implementation common
+ (void)saveProfile:(liveCommon *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.share_title forKey:share_title];
    [userDefaults setObject:user.share_des forKey:share_des];
    [userDefaults setObject:user.wx_siteurl forKey:wx_siteurl];
    [userDefaults setObject:user.ipa_ver forKey:ipa_ver];
    [userDefaults setObject:user.app_ios forKey:app_ios];
    [userDefaults setObject:user.ios_shelves forKey:ios_shelves];
    [userDefaults setObject:user.name_coin forKey:name_coin];
    [userDefaults setObject:user.name_votes forKey:name_votes];
    [userDefaults setObject:user.enter_tip_level forKey:enter_tip_level];
    
    [userDefaults setObject:user.maintain_switch forKey:maintain_switch];
    [userDefaults setObject:user.maintain_tips forKey:maintain_tips];
    [userDefaults setObject:user.live_cha_switch forKey:live_cha_switch];
    [userDefaults setObject:user.live_pri_switch forKey:live_pri_switch];
    [userDefaults setObject:user.live_time_coin forKey:live_time_coin];
    [userDefaults setObject:user.live_time_switch forKey:live_time_switch];
    [userDefaults setObject:user.live_type forKey:live_type];
    [userDefaults setObject:user.share_type forKey:share_type];
    [userDefaults setObject:user.liveclass forKey:liveclass];
    [userDefaults setObject:user.userLevel forKey:levelUser];
    [userDefaults setObject:user.anchorLevel forKey:levelanchor];
    
    [userDefaults setObject:user.sprout_key forKey:sprout_key];
    [userDefaults setObject:user.sprout_white forKey:sprout_white];
    [userDefaults setObject:user.sprout_skin forKey:sprout_skin];
    [userDefaults setObject:user.sprout_saturated forKey:sprout_saturated];
    [userDefaults setObject:user.sprout_pink forKey:sprout_pink];
    [userDefaults setObject:user.sprout_eye forKey:sprout_eye];
    [userDefaults setObject:user.sprout_face forKey:sprout_face];
    [userDefaults setObject:user.jpush_sys_roomid forKey:jpush_sys_roomid];
    [userDefaults setObject:user.qiniu_domain forKey:qiniu_domain];
    [userDefaults setObject:user.video_share_title forKey:video_share_title];
    [userDefaults setObject:user.video_share_des forKey:video_share_des];
    [userDefaults setObject:user.video_audit_switch forKey:video_audit_switch];
    [userDefaults setObject:user.tximgfolder forKey:tximgfolder];
    [userDefaults setObject:user.txvideofolder forKey:txvideofolder];
    [userDefaults setObject:user.cloudtype forKey:cloudtype];

    [userDefaults synchronize];
}
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:share_title];
    [userDefaults setObject:nil forKey:share_des];
    [userDefaults setObject:nil forKey:wx_siteurl];
    [userDefaults setObject:nil forKey:ipa_ver];
    [userDefaults setObject:nil forKey:app_ios];
    [userDefaults setObject:nil forKey:ios_shelves];
    [userDefaults setObject:nil forKey:name_coin];
    [userDefaults setObject:nil forKey:name_votes];
    [userDefaults setObject:nil forKey:enter_tip_level];
    
    [userDefaults setObject:nil forKey:maintain_tips];
    [userDefaults setObject:nil forKey:maintain_switch];
    [userDefaults setObject:nil forKey:live_pri_switch];
    [userDefaults setObject:nil forKey:live_cha_switch];
    [userDefaults setObject:nil forKey:live_time_coin];
    [userDefaults setObject:nil forKey:live_time_switch];
    [userDefaults setObject:nil forKey:live_type];
    [userDefaults setObject:nil forKey:share_type];
    [userDefaults setObject:nil forKey:liveclass];
    [userDefaults setObject:nil forKey:qiniu_domain];
    [userDefaults setObject:nil forKey:video_share_title];
    [userDefaults setObject:nil forKey:video_share_des];

    [userDefaults synchronize];
}
+ (liveCommon *)myProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    liveCommon *user = [[liveCommon alloc] init];
    user.live_time_coin = [userDefaults objectForKey:live_time_coin];
    user.live_time_switch = [userDefaults objectForKey:live_time_switch];
    
    user.share_title = [userDefaults objectForKey:share_title];
    user.share_des = [userDefaults objectForKey:share_des];
    user.wx_siteurl = [userDefaults objectForKey:wx_siteurl];
    user.ipa_ver = [userDefaults objectForKey:ipa_ver];
    user.app_ios = [userDefaults objectForKey:app_ios];
    user.ios_shelves = [userDefaults objectForKey:ios_shelves];
    user.name_coin = [userDefaults objectForKey:name_coin];
    user.name_votes = [userDefaults objectForKey:name_votes];
    user.enter_tip_level = [userDefaults objectForKey:enter_tip_level];
    
    user.maintain_switch = [userDefaults objectForKey:maintain_switch];
    user.maintain_tips = [userDefaults objectForKey:maintain_tips];
    user.live_cha_switch = [userDefaults objectForKey:live_cha_switch];
    user.live_pri_switch = [userDefaults objectForKey:live_pri_switch];
    user.live_type = [userDefaults objectForKey:live_type];
    user.share_type = [userDefaults objectForKey:share_type];
    user.liveclass = [userDefaults objectForKey:liveclass];
    user.userLevel = [userDefaults objectForKey:levelUser];
    user.anchorLevel = [userDefaults objectForKey:levelanchor];

    return user;
}
+(NSString *)name_coin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name_coinss = [userDefaults objectForKey: name_coin];
    return name_coinss;
}
+(NSString *)name_votes{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name_votesss = [userDefaults objectForKey: name_votes];
    return name_votesss;
}
+(NSString *)enter_tip_level{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* enter_tip_levelss = [userDefaults objectForKey: enter_tip_level];
    return enter_tip_levelss;
}
+(NSString *)share_title{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_titles = [userDefaults objectForKey: share_title];
    return share_titles;
}
+(NSString *)share_des{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_dess = [userDefaults objectForKey: share_des];
    return share_dess;
}
+(NSString *)wx_siteurl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* wx_siteurls = [userDefaults objectForKey: wx_siteurl];
    return wx_siteurls;
}
+(NSString *)ipa_ver{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ipa_vers = [userDefaults objectForKey: ipa_ver];
    return ipa_vers;
}
+(NSString *)app_ios{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* app_ioss = [userDefaults objectForKey: app_ios];
    return app_ioss;
}
+(NSString *)ios_shelves{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ios_shelvess = [userDefaults objectForKey: ios_shelves];
    return ios_shelvess;
}

+(NSString *)maintain_tips {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_tipss = [userDefaults objectForKey: maintain_tips];
    
    return maintain_tipss;
}
+(NSString *)maintain_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_switchs = [userDefaults objectForKey:maintain_switch];
    
    return maintain_switchs;
}
+(NSString *)live_pri_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_pri_switchs = [userDefaults objectForKey:live_pri_switch];
    return live_pri_switchs;
}
+(NSString *)live_cha_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_cha_switchs = [userDefaults objectForKey:live_cha_switch];
    return live_cha_switchs;
}
+(NSString *)live_time_switch{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_time_switchs = [userDefaults objectForKey:live_time_switch];
    return live_time_switchs;
    
}
+(NSArray *)live_time_coin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *live_cha_switchs = [userDefaults objectForKey:live_time_coin];
    return live_cha_switchs;
}
+(NSArray  *)live_type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *livetypes = [userDefaults objectForKey:live_type];
    return livetypes;
    
}
+(NSArray  *)share_type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *share_typess = [userDefaults objectForKey:share_type];
    return share_typess;
    
}
+(NSArray *)liveclass{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *liveclasss = [userDefaults objectForKey:liveclass];
    return liveclasss;
}



//保存声网
+(void)saveagorakitid:(NSString *)agorakitids{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:agorakitids forKey:agorakitid];
    [userDefaults synchronize];
}
+(NSString  *)agorakitid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *agorakitidss = [userDefaults objectForKey:agorakitid];
    return agorakitidss;
    
}
//保存个人中心选项缓存
+(void)savepersoncontroller:(NSArray *)arrays{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:arrays forKey:personc];
    [userDefaults synchronize];
}
+(NSArray *)getpersonc{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *personcs = [userDefaults objectForKey:personc];
    return personcs;
    
}
+(NSDictionary *)getUserLevelMessage:(NSString *)level{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *levelArr = [userDefaults objectForKey:levelUser];
    NSDictionary *dic;
    if ([levelArr isKindOfClass:[NSArray class]]) {
        if ([level integerValue] - 1 < levelArr.count) {
            dic = levelArr[[level integerValue] - 1];
        }else{
            dic = [levelArr lastObject];
        }
    }else{
        dic = @{
                @"levelid": @"0",
                @"thumb": @"123",
                @"colour": @"#000000",
                @"thumb_mark": @"123"
                };
    }
    return dic;
}
+(NSDictionary *)getAnchorLevelMessage:(NSString *)level{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *levelArr = [userDefaults objectForKey:levelanchor];
    NSDictionary *dic;
    if ([levelArr isKindOfClass:[NSArray class]]) {
        if ([level integerValue] - 1 < levelArr.count) {
            dic = levelArr[[level integerValue] - 1];
        }else{
            dic = [levelArr lastObject];
        }
    }else{
        dic = @{
            @"levelid": @"0",
            @"thumb": @"123",
            @"colour": @"#000000",
            @"thumb_mark": @"123"
            };
    }
    return dic;
}


+(NSString *)sprout_key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_key];
    return sprout_keyss;
    
}
+(NSString *)sprout_white{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_white];
    return sprout_keyss;
    
}
+(NSString *)sprout_skin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_skin];
    return sprout_keyss;
    
}
+(NSString *)sprout_saturated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_saturated];
    return sprout_keyss;
    
}
+(NSString *)sprout_pink{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_pink];
    return sprout_keyss;
    
}
+(NSString *)sprout_eye{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_eye];
    return sprout_keyss;
    
}
+(NSString *)sprout_face{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:sprout_face];
    return sprout_keyss;
    
}
+(NSString *)jpush_sys_roomid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:jpush_sys_roomid];
    return sprout_keyss;
}
+(NSString *)qiniu_domain{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sprout_keyss = [userDefaults objectForKey:qiniu_domain];
    return sprout_keyss;
}
+(NSString *)video_share_des{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* share_titles = [userDefaults objectForKey: video_share_des];
    return share_titles;
}
+(NSString *)video_share_title{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* share_titles = [userDefaults objectForKey: video_share_title];
    return share_titles;
}
#pragma mark - 后台审核开关
+(NSString *)getAuditSwitch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *auditSwitch = [userDefaults objectForKey:video_audit_switch];
    return auditSwitch;
}
#pragma mark - 腾讯空间
+(NSString *)getTximgfolder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *auditSwitch = [userDefaults objectForKey:tximgfolder];
    return auditSwitch;
}
+(NSString *)getTxvideofolder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *auditSwitch = [userDefaults objectForKey:txvideofolder];
    return auditSwitch;
}
#pragma mark - 存储类型（七牛-腾讯）
+(NSString *)cloudtype{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cloudtypess = [userDefaults objectForKey:cloudtype];
    return cloudtypess;
}
//腾讯appid
+(void)saveTXSDKAppID:(NSString *)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:save forKey:@"rk_tx_appid"];
    [userDefaults synchronize];
}
+(NSString *)getTXSDKAppID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *getStr = [userDefaults objectForKey:@"rk_tx_appid"];
    return getStr;
}

//梦颜参数 0梦颜  1-腾讯
+(void)saveIsTXfiter:(NSString *)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:save forKey:@"rk_ti_tx_fiter"];
    [userDefaults synchronize];
}
+(NSString *)getIsTXfiter {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *getStr = [userDefaults objectForKey:@"rk_ti_tx_fiter"];
    return getStr;
}
@end
