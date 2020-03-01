#import <Foundation/Foundation.h>
@interface messageModel : NSObject
@property(nonatomic,copy)NSString *imageIcon;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *unReadMessage;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)JMSGConversation *conversations;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
