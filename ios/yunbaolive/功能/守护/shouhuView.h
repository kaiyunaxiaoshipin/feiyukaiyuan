//
//  shouhuView.h
//  yunbaolive
//
//  Created by Boom on 2018/8/9.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol shouhuViewDelegate <NSObject>
- (void)removeShouhuView;
-(void)pushCoinV;
- (void)buyShouhuSuccess:(NSDictionary *)dic;
@end

@interface shouhuView : UIView<UIAlertViewDelegate>
@property(nonatomic,assign)id<shouhuViewDelegate> delegate;
@property (nonatomic,strong)NSString *liveUid;
@property (nonatomic,strong)NSString *stream;
@property (nonatomic,strong)NSString *guardType;

- (void)requestData;
- (void)show;
- (void)goBuy;
@end
