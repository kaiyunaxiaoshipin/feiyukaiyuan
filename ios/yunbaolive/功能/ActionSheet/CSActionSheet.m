//
//  CSActionSheet.m
//
//
//  Created by e3mo on 15/7/7.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "CSActionSheet.h"

#define SYS_CELL_HEIGHT             50.f
#define SYS_CELL_LABEL_SIZE         15.f

@implementation CSActionSheet

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles cancal:(NSString *)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color {
    return [self initWithFrame:frame titles:titles cancal:cancal normal_color:normalColor highlighted_color:color tips:nil tipsColor:nil cellBgColor:[UIColor whiteColor] cellLineColor:[UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1]];
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles cancal:(NSString *)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color tips:(NSString*)tips tipsColor:(UIColor*)tipsColor {
    
    return [self initWithFrame:frame titles:titles cancal:cancal normal_color:normalColor highlighted_color:color tips:tips tipsColor:tipsColor cellBgColor:[UIColor whiteColor] cellLineColor:[UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1]];
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles cancal:(NSString *)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color tips:(NSString *)tips tipsColor:(UIColor *)tipsColor cellBgColor:(UIColor *)bgColor cellLineColor:(UIColor *)lineColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        isInAction = NO;
        
        titles_array = [[NSArray alloc] initWithArray:titles];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        close_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [close_btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [close_btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        [close_btn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close_btn];
        
        [self initShowView:cancal normal_color:normalColor highlighted_color:color tips:tips tipsColor:tipsColor bgColor:bgColor lineColor:lineColor];
    }
    
    return self;
}

- (void)initShowView:(NSString*)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color tips:(NSString *)tips tipsColor:(UIColor *)tipsColor bgColor:(UIColor*)bgColor lineColor:(UIColor*)lineColor {
    show_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    [show_view setBackgroundColor:[UIColor clearColor]];
    [self addSubview:show_view];
    
    float picker_height = 0;
    
    if (tips && tips.length > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, show_view.frame.size.width-20, 0)];
        [label setText:tips];
        if (tipsColor) {
            [label setTextColor:tipsColor];
        }
        else {
            [label setTextColor:[UIColor grayColor]];
        }
        [label setTextAlignment:NSTextAlignmentCenter];
        label.numberOfLines = 0;
        [label setFont:[UIFont systemFontOfSize:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label sizeToFit];
        CGRect frame = label.frame;
        frame.size.width = show_view.frame.size.width-20;
        label.frame = frame;
        
        UIImageView *tips_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, show_view.frame.size.width, label.frame.size.height+20)];
        [tips_bg setBackgroundColor:bgColor];
        [show_view addSubview:tips_bg];
        
        [tips_bg addSubview:label];
        
        picker_height += tips_bg.frame.size.height;
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, picker_height-1, show_view.frame.size.width, 1)];
        [line1 setBackgroundColor:[UIColor darkGrayColor]];
        [tips_bg addSubview:line1];
    }
    
    
    UIImageView *picker_bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, picker_height, show_view.frame.size.width-20, titles_array.count*SYS_CELL_HEIGHT)];
    [picker_bg setBackgroundColor:bgColor];
    picker_bg.layer.cornerRadius = 8;
    picker_bg.layer.masksToBounds = YES;
    [show_view addSubview:picker_bg];
    
    for (int i=0; i<titles_array.count; i++) {
        NSString *title = [titles_array objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, picker_height+i*SYS_CELL_HEIGHT, picker_bg.frame.size.width, SYS_CELL_HEIGHT)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        if (color) {
            [btn setTitleColor:color forState:UIControlStateHighlighted];
        }
        [btn.titleLabel setFont:[UIFont systemFontOfSize:SYS_CELL_LABEL_SIZE]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(sureBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i+1];
        [show_view addSubview:btn];
        
        if (i != 0) {
            UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*SYS_CELL_HEIGHT-0.5, show_view.frame.size.width, 1)];
            [line1 setBackgroundColor:lineColor];
            [picker_bg addSubview:line1];
        }
    }
    
    picker_height += titles_array.count * SYS_CELL_HEIGHT;
    
    UIImageView *cancal_bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, picker_height+5, show_view.frame.size.width-20, SYS_CELL_HEIGHT)];
    [cancal_bg setBackgroundColor:bgColor];
    cancal_bg.layer.cornerRadius = 8;
    cancal_bg.layer.masksToBounds = YES;
    [show_view addSubview:cancal_bg];
    
    cancal_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancal_btn setFrame:CGRectMake(10, picker_height+5, cancal_bg.frame.size.width, SYS_CELL_HEIGHT)];
    [cancal_btn setTitle:cancal forState:UIControlStateNormal];
    [cancal_btn setTitleColor:normalColor forState:UIControlStateNormal];
    if (color) {
        [cancal_btn setTitleColor:color forState:UIControlStateHighlighted];
    }
    [cancal_btn.titleLabel setFont:[UIFont systemFontOfSize:SYS_CELL_LABEL_SIZE]];
    [cancal_btn setBackgroundColor:[UIColor clearColor]];
    [cancal_btn addTarget:self action:@selector(sureBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    cancal_btn.tag = 0;
    [show_view addSubview:cancal_btn];
    
    
    CGRect frame = show_view.frame;
    frame.size.height = picker_height + cancal_bg.frame.size.height + 5;
    show_view.frame = frame;
    
}

- (void)setCancalLabelColor:(UIColor*)color highlightedColor:(UIColor*)highColor {
    if (color) {
        [cancal_btn setTitleColor:color forState:UIControlStateNormal];
    }
    [cancal_btn setTitleColor:highColor forState:UIControlStateHighlighted];
}

- (void)sureBtnTouched:(id)sender {
    UIButton *btn = (UIButton*)sender;

    if (self.action) {
        self.action((int)btn.tag, self);
    }
}

- (void)closeBtnTouched:(id)sender {
    if (isInAction) {
        return;
    }
    
    [self hideView];
}

- (void)showView:(void (^)(int, id))action close:(void (^)(id))close {
    self.action = action;
    self.close = close;
    
    if (isInAction) {
        return;
    }
    isInAction = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = show_view.frame;
        frame.origin.y = self.frame.size.height-frame.size.height;
        show_view.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            isInAction = NO;
        }
    }];
}

- (void)hideView {
    if (isInAction) {
        return;
    }
    isInAction = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = show_view.frame;
        frame.origin.y = self.frame.size.height;
        show_view.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            isInAction = NO;
            
            if (self.close) {
                self.close(self);
            }
        }
    }];
}

- (BOOL)viewIsInAction {
    return isInAction;
}

@end
