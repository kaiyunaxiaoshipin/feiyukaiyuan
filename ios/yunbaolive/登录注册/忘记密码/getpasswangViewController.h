//
//  getpasswangViewController.h
//  yunbaolive
//
//  Created by zqm on 16/9/19.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getpasswangViewController : UIViewController


- (IBAction)doBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;


@property (weak, nonatomic) IBOutlet UITextField *futurePassWord;
@property (weak, nonatomic) IBOutlet UITextField *futurePassWord2;
- (IBAction)doChangePassWord:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dochange;

@end
