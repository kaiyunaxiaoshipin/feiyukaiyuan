//
//  MessageHeaderV.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MsgBlock)(NSString *type);

@interface MessageHeaderV : UIView

@property(nonatomic,copy)MsgBlock msgEvent;

@property (weak, nonatomic) IBOutlet UIView *headerBgV;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *aiTeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

- (IBAction)clickFansBtn:(UIButton *)sender;
- (IBAction)clickZanBtn:(UIButton *)sender;
- (IBAction)clickAiTeBtn:(UIButton *)sender;
- (IBAction)clickCommentBtn:(UIButton *)sender;

@end
