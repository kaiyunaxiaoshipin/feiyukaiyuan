//
//  WPFButton.h
//  01-幸运转盘第二遍
//
//  Created by 王鹏飞 on 16/1/13.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kBtnTypeAnimal,
    kBtnTypeAstrology
} kBtnType;

@interface WPFButton : UIButton

@property (nonatomic, assign) kBtnType type;

@end
