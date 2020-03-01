
#import <Foundation/Foundation.h>

@interface listModel : NSObject

@property(nonatomic,copy)NSString *iconName;

@property(nonatomic,copy)NSString *userID;

@property(nonatomic,copy)NSString *user_nicename;

@property(nonatomic,copy)NSString *level;

@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *signature;

@property(nonatomic,copy)NSString *sex;
@property(nonatomic,strong)NSString *contribution;
@property(nonatomic,strong)NSString *guard_type;

@property(nonatomic,assign)NSNumber *vip_type;
//vip图片
@property(nonatomic,copy)NSString *vip_thumb;

-(instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
