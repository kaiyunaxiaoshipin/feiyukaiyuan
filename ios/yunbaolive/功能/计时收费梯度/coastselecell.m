//
//  coastselecell.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "coastselecell.h"

@implementation coastselecell

+(coastselecell *)cellWithTableView:(UITableView *)tableview{
    coastselecell *cell = [tableview dequeueReusableCellWithIdentifier:@"coastselecell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"coastselecell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
