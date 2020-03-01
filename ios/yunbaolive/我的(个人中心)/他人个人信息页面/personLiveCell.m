//
//  personLiveCell.m
//  yunbaolive
//
//  Created by Boom on 2018/10/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "personLiveCell.h"

@implementation personLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LiveNodeModel *)model{
    
    _model = model;
    self.labTitle.text = _model.title;
    self.labStartTime.text = _model.datestarttime;
    self.labNums.text = _model.nums;
}

@end
