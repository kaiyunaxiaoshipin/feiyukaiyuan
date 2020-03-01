
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface chatModel : NSObject

@property(nonatomic,copy)NSString *titleColor;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *contentChat;

@property(nonatomic,copy)NSString *signature;

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *vip_type;

@property(nonatomic,copy)NSString *liangname;

@property(nonatomic,copy)NSString *isAnchor;

@property(nonatomic,copy)NSString *isadmin;

@property(nonatomic,copy)NSString *guardType;

@property(nonatomic,assign)CGRect vipR;

@property(nonatomic,assign)CGRect liangR;

@property(nonatomic,copy)NSString *levelI;

@property(nonatomic,copy)NSString *userID;

@property(nonatomic,copy)NSString *icon;

@property(nonatomic,assign)CGFloat rowHH;

@property(nonatomic,assign)CGRect nameR;

@property(nonatomic,assign)CGRect NAMER;


@property(nonatomic,assign)CGRect cotentchatR;

@property(nonatomic,assign)CGRect levelR;

@property(nonatomic,assign)CGRect contentR;


-(instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)modelWithDic:(NSDictionary *)dic;


-(void)setChatFrame:(chatModel *)upChat;

@end
