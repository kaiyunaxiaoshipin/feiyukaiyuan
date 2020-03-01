//
//  zhuanglistcell.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/20.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "zhuanglistcell.h"

@implementation zhuanglistcell

+(zhuanglistcell *)cellWithTableview:(UITableView *)tableview{
    zhuanglistcell *cell = [tableview dequeueReusableCellWithIdentifier:@"zhuanglistcell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"zhuanglistcell" owner:self options:nil].lastObject;
    }
    return cell;    
}
-(void)setfirstitem{
    self.zhuangname.text = YZMsg(@"顺序");
    self.usernameL.text  = YZMsg(@"玩家");
    self.moneyL.text     = YZMsg(@"游戏币");
    
    
    self.zhuangname.textColor = [UIColor whiteColor];
    self.usernameL.textColor  = [UIColor whiteColor];
    self.moneyL.textColor     = [UIColor whiteColor];
    
    
}
-(void)setmodel:(NSDictionary *)dic{
    
    
    self.zhuangname.text = YZMsg(@"庄");
    self.usernameL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
    self.moneyL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"coin"]];
    
    
    self.zhuangname.textColor = normalColors;
    self.usernameL.textColor  = normalColors;
    self.moneyL.textColor     = normalColors;
    
    
}
@end
