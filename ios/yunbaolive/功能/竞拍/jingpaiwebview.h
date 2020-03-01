//
//  jingpaiwebview.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/28.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^taskblocks)(NSString *task);

typedef void (^aaaxinblock)(NSString *type);


@interface jingpaiwebview : UIView
{
    NSString *userBaseUrl;
    UIWebView  *jingpaiweb;
}
-(void)loadrequest:(NSString *)stream;
-(instancetype)initWithFrame:(CGRect)frame andblock:(aaaxinblock)blocks andcancle:(aaaxinblock)cancleblock;
@end
