#import <Foundation/Foundation.h>
@interface hunyinModel : NSObject
@property(nonatomic,copy)NSString *songname;
@property(nonatomic,copy)NSString *artistname;
@property(nonatomic,copy)NSString *songid;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
