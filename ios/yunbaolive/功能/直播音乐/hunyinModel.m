
#import "hunyinModel.h"

@implementation hunyinModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    
    self = [super init];
    
    if (self) {
        _artistname = [dic valueForKey:@"artist_name"];
        _songname = [dic valueForKey:@"audio_name"];
        _songid = [dic valueForKey:@"audio_id"];
        
    }
    return self;
}


+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    return [[self alloc]initWithDic:dic];
}
@end
