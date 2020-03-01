//
//  catSwitch.h
//  yunbaolive
//
//  Created by 志刚杨 on 16/7/2.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol catSwitchDelegate <NSObject>

-(void)switchState:(BOOL)state;

@end

@interface catSwitch : UIView
@property (nonatomic,strong) NSString *offString;
@property (nonatomic,strong) NSString *onString;
@property(assign,nonatomic)id<catSwitchDelegate> delegate;
@property BOOL state;
@end
