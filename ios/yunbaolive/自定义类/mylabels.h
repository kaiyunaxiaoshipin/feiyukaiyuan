//
//  mylabels.h
//  yunbaolive
//
//  Created by zqm on 16/8/30.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface mylabels : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}


@property (nonatomic) VerticalAlignment verticalAlignment;

-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment;

@end
