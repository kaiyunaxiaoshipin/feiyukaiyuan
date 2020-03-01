//
//  twEmojiView.h
//  TaiWanEight
//
//  Created by Boom on 2017/11/23.
//  Copyright © 2017年 YangBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWLCollectionViewHorizontalLayout.h"

#define EmojiHeight 200

@protocol twEmojiViewDelegate <NSObject>

- (void)sendimage:(NSString *)str;
-(void)clickSendEmojiBtn;

@end
@interface twEmojiView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)id <twEmojiViewDelegate> delegate;

@property(nonatomic,strong)UIButton *sendEmojiBtn;

@end
