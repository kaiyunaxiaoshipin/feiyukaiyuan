//
//  adminLists.h
//  yunbaolive
//
//  Created by zqm on 16/5/22.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol adminDelegate <NSObject>
-(void)setAdminSuccess:(NSString *)isadmin andName:(NSString *)name andID:(NSString *)ID;
- (void)adminZhezhao;
@end

@interface adminLists : UIViewController
@property(nonatomic,weak)id <adminDelegate> delegate;

@end
