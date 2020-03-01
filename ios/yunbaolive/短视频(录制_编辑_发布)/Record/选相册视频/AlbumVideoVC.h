//
//  AlbumVideoVC.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelVideoBlock)(NSString *path);

@interface AlbumVideoVC : UIViewController

@property(nonatomic,copy)SelVideoBlock selEvent;

@end
