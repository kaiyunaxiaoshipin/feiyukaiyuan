//
//  LiveNodeModel.h
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveNodeModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *datestarttime;
@property (nonatomic,copy) NSString *dateendtime;
@property (nonatomic,copy) NSString *nums;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
