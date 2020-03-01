

#import "listModel.h"

@interface listModel ()


@end

@implementation listModel

/*
 avatar = "http://yy.yunbaozhibo.com/public/upload/avatar/20160422/05146623245138220.png";
 city = "";
 coin = 94372144;
 consumption = 5627855;
 experience = 56278550;
 id = 68;
 islive = 1;
 isrecommend = 0;
 level = 9;
 province = "";
 sex = 1;
 sign = 954d72241e446ef67d999838d1a9c844;
 signature = "\U8fd9\U5bb6\U4f19\U5f88\U61d2\Uff0c\U4ec0\U4e48\U90fd\U6ca1\U7559\U4e0b\U8003\U8651\U8003\U8651\U62d2\U7edd\U4e86\U770b";
 userType = 30;
 "user_nicename" = "\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8";
 votes = 418304;
 votestotal = 421504;
 
 */

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        
        _iconName = minstr([dic valueForKey:@"avatar"]);
        _userID =minstr([dic valueForKey:@"id"]);
        _user_nicename = minstr([dic valueForKey:@"user_nicename")];
        _signature = minstr([dic valueForKey:@"signature"]);
        _sex = minstr([dic valueForKey:@"sex"]);
        _level = minstr([dic valueForKey:@"level"]);
        _contribution = minstr([dic valueForKey:@"contribution"]);

        if ([_city isEqual:[NSNull null]] || _city == NULL || _city == nil || [_city isEqual:@"(null)"]) {
            _city = @"定位在火星";
        }
        else{
            _city = [dic valueForKey:@"city"];
        }
        _vip_thumb = [dic valueForKey:@"vip_thumb"];
        _vip_type = [dic valueForKey:@"vip_type"];
        _guard_type = minstr([dic valueForKey:@"guard_type"]);
    }
    return self;
    
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    return   [[self alloc]initWithDic:dic];
}

@end
