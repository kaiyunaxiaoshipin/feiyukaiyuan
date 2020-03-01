//
//  JCHATMessageTableView.h
//  JChat
//
//  Created by HuminiOS on 15/10/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchMsgTabDelegate <NSObject>
- (void)msgTableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
@end

@interface JCHATMessageTableView : UITableView

@property (nonatomic,assign) id<TouchMsgTabDelegate> touchDelegate;


@property(assign,nonatomic)BOOL isFlashToLoad;

- (void)loadMoreMessage;
@end
