//
//  shareImgView.h
//  yunbaolive
//
//  Created by IOS1 on 2019/4/29.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareImgView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *appNameL;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *userIDL;
@property (weak, nonatomic) IBOutlet UILabel *invitationL;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *userIconSmall;

@end

NS_ASSUME_NONNULL_END
