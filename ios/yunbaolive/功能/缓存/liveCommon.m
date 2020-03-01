//
//  liveCommon.m
//  
//
//  Created by 王敏欣 on 2017/1/18.
//
//
#import "liveCommon.h"
@implementation liveCommon
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        
        _share_title = minstr([dic valueForKey:@"share_title"]);
        _share_des = minstr([dic valueForKey:@"share_des"]);
        _wx_siteurl = minstr([dic valueForKey:@"wx_siteurl"]);
        _ipa_ver = minstr([dic valueForKey:@"ipa_ver"]);
        _app_ios = minstr([dic valueForKey:@"app_ios"]);
        _ios_shelves =[NSString stringWithFormat:@"%@",[dic valueForKey:@"ios_shelves"]];
        _name_coin = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name_coin"]];
        _name_votes = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name_votes"]];
        _enter_tip_level = [NSString stringWithFormat:@"%@",[dic valueForKey:@"enter_tip_level"]];
        
        _maintain_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"maintain_switch"]];
        _maintain_tips = [NSString stringWithFormat:@"%@",[dic valueForKey:@"maintain_tips"]];
        _live_cha_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"live_cha_switch"]];
        _live_pri_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"live_pri_switch"]];
        _live_time_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"live_time_switch"]];
        _live_time_coin = [dic valueForKey:@"live_time_coin"];
        _live_type = [dic valueForKey:@"live_type"];
        
        _liveclass = [dic valueForKey:@"liveclass"];
        _userLevel = [dic valueForKey:@"level"];
        _anchorLevel = [dic valueForKey:@"levelanchor"];
        
        _sprout_eye = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_eye"]];
        _sprout_white = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_white"]];
        _sprout_key = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_key"]];
        _sprout_pink = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_pink"]];
        _sprout_face = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_face"]];
        _sprout_saturated = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_saturated"]];
        _sprout_skin = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sprout_skin"]];
        _jpush_sys_roomid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"jpush_sys_roomid"]];
        _video_share_title = minstr([dic valueForKey:@"video_share_title"]);
        _video_share_des = minstr([dic valueForKey:@"video_share_des"]);
        _qiniu_domain = minstr([dic valueForKey:@"qiniu_domain"]);

        _tximgfolder = [NSString stringWithFormat:@"%@",[dic valueForKey:@"tximgfolder"]];
        _txvideofolder = minstr([dic valueForKey:@"txvideofolder"]);
        _video_audit_switch = minstr([dic valueForKey:@"video_audit_switch"]);
        _cloudtype = minstr([dic valueForKey:@"cloudtype"]);

        id shareTYPE = [dic valueForKey:@"share_type"];
        if ([shareTYPE isKindOfClass:[NSArray class]]) {
            _share_type = [dic valueForKey:@"share_type"];
        }else{
            _share_type = @[];
        }

    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
