//
//  CSActionPicker.m
//  NotePad
//
//  Created by e3mo on 16/8/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "CSActionPicker.h"

#define SYS_MAX_HEIGHT              300.f
#define SYS_CELL_HEIGHT             50.f
#define SYS_CELL_LABEL_SIZE         16.f

@implementation CSActionPicker

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color {
    return [self initWithFrame:frame titles:titles normal_color:normalColor highlighted_color:color cellBgColor:[UIColor whiteColor] cellLineColor:[UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1]];
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color cellBgColor:(UIColor *)bgColor cellLineColor:(UIColor *)lineColor {
    
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
        
        [self initShowViewWithNormal_color:normalColor highlighted_color:color bgColor:bgColor lineColor:lineColor];
    }
    
    return self;
}

- (void)initShowViewWithNormal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color bgColor:(UIColor*)bgColor lineColor:(UIColor*)lineColor {
    show_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
    [show_view setBackgroundColor:[UIColor clearColor]];
    [self addSubview:show_view];
    
    float picker_height = 0;
    
    
    if (titles_array.count > 6) {
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, show_view.frame.size.width, SYS_MAX_HEIGHT)];
        [scrollview setBackgroundColor:bgColor];
        [scrollview setScrollEnabled:YES];//能否滑动
        [scrollview setShowsHorizontalScrollIndicator:NO];
        [scrollview setShowsVerticalScrollIndicator:YES];
        [scrollview setPagingEnabled:NO];//设置是否按页翻动
        [scrollview setBounces:NO];//设置是否反弹
        [scrollview setIndicatorStyle:UIScrollViewIndicatorStyleDefault];//设置风格
        [scrollview setDirectionalLockEnabled:NO];//设置是否同时运动
        
        UIView *sc_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollview.frame.size.width, titles_array.count*SYS_CELL_HEIGHT)];
        [sc_view setBackgroundColor:[UIColor clearColor]];
        
        for (int i=0; i<titles_array.count; i++) {
            NSString *title = [titles_array objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, picker_height+i*SYS_CELL_HEIGHT, scrollview.frame.size.width, SYS_CELL_HEIGHT)];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
            if (color) {
                [btn setTitleColor:color forState:UIControlStateHighlighted];
            }
            [btn.titleLabel setFont:[UIFont systemFontOfSize:SYS_CELL_LABEL_SIZE]];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(sureBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [sc_view addSubview:btn];
            
            if (i != 0) {
                UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*SYS_CELL_HEIGHT-0.5, show_view.frame.size.width, 1)];
                [line1 setBackgroundColor:lineColor];
                [sc_view addSubview:line1];
            }
        }
        
        [scrollview addSubview:sc_view];
        
        [scrollview setContentSize:CGSizeMake(sc_view.frame.size.width, sc_view.frame.size.height)];//设置滑动范围
        [show_view addSubview:scrollview];
        
        picker_height += SYS_MAX_HEIGHT;
    }
    else {
        UIImageView *picker_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, picker_height, show_view.frame.size.width, titles_array.count*SYS_CELL_HEIGHT)];
        [picker_bg setBackgroundColor:bgColor];
        [show_view addSubview:picker_bg];
        
        for (int i=0; i<titles_array.count; i++) {
            NSString *title = [titles_array objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, picker_height+i*SYS_CELL_HEIGHT, picker_bg.frame.size.width, SYS_CELL_HEIGHT)];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:normalColor forState:UIControlStateNormal];
            if (color) {
                [btn setTitleColor:color forState:UIControlStateHighlighted];
            }
            [btn.titleLabel setFont:[UIFont systemFontOfSize:SYS_CELL_LABEL_SIZE]];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(sureBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [show_view addSubview:btn];
            
            if (i != 0) {
                UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*SYS_CELL_HEIGHT-0.5, show_view.frame.size.width, 1)];
                [line1 setBackgroundColor:lineColor];
                [picker_bg addSubview:line1];
            }
        }
        
        picker_height += titles_array.count * SYS_CELL_HEIGHT;

    }
    
    CGRect frame = show_view.frame;
    frame.size.height = picker_height;
    frame.origin.y = -frame.size.height;
    show_view.frame = frame;
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
    if (isInAction) {
        return;
    }
    self.action = action;
    self.close = close;
    
    isInAction = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = show_view.frame;
        frame.origin.y = 0;
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
        frame.origin.y = -show_view.frame.size.height;
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
