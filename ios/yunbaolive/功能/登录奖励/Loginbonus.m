//
//  Loginbonus.m
//  yunbaolive
//
//  Created by Rookie on 2017/4/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "Loginbonus.h"
#import "LogFirstCell.h"
#import "LogFirstCell2.h"

static NSString* IDENTIFIER = @"collectionCell";

static NSString *IDENTIFIER2 = @"collectionCell2";

@interface Loginbonus ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CADisplayLink *_link;
    LogFirstCell *selectCell;
    LogFirstCell2 *selectCell2;
    UIImageView *sevendayimageview;
    NSString *logDayCount;

    NSString *logDay;
    NSArray *numArr ;
    UIView *whiteView;
    
}
@property (nonatomic,assign) NSArray *arrays;

@end

@implementation Loginbonus
#define speace 10*_window_width/375
/******************  登录奖励 ->  ********************/

-(instancetype)initWithFrame:(CGRect)frame AndNSArray:(NSArray *)arrays AndDay:(NSString *)day andDayCount:(NSString *)dayCount{
    
    self = [super initWithFrame:frame];
    if (self) {
        _arrays = arrays;
        logDay = day;
        logDayCount = dayCount;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self firstLog:frame];
    }
    return self;
    
}

-(void)firstLog:(CGRect)frame {
    CGFloat height = _window_width *0.9*26/66.00+80+(_window_width *0.9*0.88 - 30)/4*(140/116.00)*2;

    whiteView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.05, -_window_height, _window_width*0.9, height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10.0;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    CGFloat fcX = 0;
    CGFloat fcY = 0;
    CGFloat fcW = whiteView.width;
    CGFloat fcH = whiteView.height;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _firstCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(fcX, fcY, fcW, fcH) collectionViewLayout:layout];
    
    _firstCollection.dataSource = self;
    _firstCollection.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"LogFirstCell" bundle:nil];
    [_firstCollection registerNib:nib forCellWithReuseIdentifier:IDENTIFIER];
    UINib *nib2 = [UINib nibWithNibName:@"LogFirstCell2" bundle:nil];
    [_firstCollection registerNib:nib2 forCellWithReuseIdentifier:IDENTIFIER2];
    
    [_firstCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [_firstCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _firstCollection.backgroundColor = [UIColor whiteColor];
    
    [whiteView addSubview:_firstCollection];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                whiteView.frame = CGRectMake(_window_width*0.05, _window_height*0.2, _window_width*0.9, height);
            }];
        });
    });

    
}
- (void)showLogSucessAnimation{
    [whiteView removeFromSuperview];
    whiteView = nil;
    UIImageView *lightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.25, _window_height/2-_window_width*0.125-50, _window_width*0.5, _window_width*0.5)];
    lightImageView.image = [UIImage imageNamed:@"logFirst_背景"];
    [self addSubview:lightImageView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999;
    [lightImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = NO;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:0.2];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.2];     //结束伸缩倍数
    
    
    
    
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(lightImageView.left, lightImageView.top-lightImageView.width/3, lightImageView.width, lightImageView.width/3)];
    headerImgView.image = [UIImage imageNamed:@"logFirst_成功"];
    [self addSubview:headerImgView];
    
    
    UIImageView *coinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.375, lightImageView.width*0.25+lightImageView.top, _window_width*0.25, _window_width*0.25)];
    coinImageView.image = [UIImage imageNamed:@"logFirst_钻石"];
    [self addSubview:coinImageView];
    
    [headerImgView.layer addAnimation:animation forKey:nil];
    [coinImageView.layer addAnimation:animation forKey:nil];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, coinImageView.bottom+5, _window_width, 22)];
    label.textColor = normalColors;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *subdic = _arrays[[logDay intValue]-1];
    label.text = [NSString stringWithFormat:@"+ %@",minstr([subdic valueForKey:@"coin"])];
    [self addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label.layer addAnimation:animation forKey:nil];
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(removeView:)]) {
                [_delegate removeView:nil];
            }
        }];
        
    });

}
-(void)clickReceiveBtn {
    [YBToolClass postNetworkWithUrl:@"User.getBonus" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [self showLogSucessAnimation];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        [MBProgressHUD showError:YZMsg(@"网络错误")];

    }];

    /*
    CGRect originFrame;
    if ([logDay integerValue] == 7) {
        originFrame = [self  convertRect:sevendayimageview.frame fromView:sevendayimageview];
        originFrame.origin.x = originFrame.origin.x-originFrame.size.width;
        
    }else {
        originFrame = [self  convertRect:selectCell.imageIV.frame fromView:selectCell];
    }
    CGFloat x = originFrame.origin.x;
    CGFloat y = originFrame.origin.y;
    CGFloat w = originFrame.size.width;
    CGFloat h = originFrame.size.height;
    
    NSDictionary *dic = @{
                          @"x":@(x),
                          @"y":@(y),
                          @"w":@(w),
                          @"h":@(h),
                          @"image":[logDay intValue]<7?selectCell.imageIV.image:sevendayimageview.image
                          };
    
    if ([_delegate respondsToSelector:@selector(removeView:)]) {
        [_delegate removeView:dic];
    }
     */

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrays.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    if (indexPath.row  == 6) {
        LogFirstCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER2 forIndexPath:indexPath];
        
        cell = cell2;
        
    } else {
        
        LogFirstCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];
        
        cell1.layer.cornerRadius = 3;
        cell1.layer.masksToBounds = YES;
        NSDictionary *subdic = _arrays[indexPath.row];
        cell1.titleL.text = minstr([subdic valueForKey:@"day"]);
        
        if (indexPath.item <= [logDay integerValue]-1) {
            cell1.bgIV.image = [UIImage imageNamed:@"logFirst_已领取"];
        }
        //判断第几天
        if (indexPath.item == [logDay integerValue]-1) {
            //动画
//            cell1.bgIV2.image = [UIImage imageNamed:@"sel"];
            selectCell = cell1;
            if (nil == _link) {
                // 实例化计时器
                _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepRatate)];
                // 添加到当前运行循环中
                [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            } else {
                // 如果不为空，就关闭暂停
                _link.paused = NO;
            }
        }
        cell = cell1;
    }
    return cell;
}

- (void)keepRatate {
    if ([logDay integerValue] == 7) {
        selectCell2.bgIV2.transform = CGAffineTransformRotate(selectCell2.bgIV2.transform, M_PI_4 * 0.02);
    }else {
        selectCell.bgIV2.transform = CGAffineTransformRotate(selectCell.bgIV2.transform, M_PI_4 * 0.02);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
        
        CGFloat W = (whiteView.width*0.88 - 3*speace)/4*2+speace;
        CGFloat H = (whiteView.width*0.88 - 3*speace)/4*(140/116.00);
        return CGSizeMake(W, H);
    }else {
        CGFloat W = (whiteView.width*0.88 - 3*speace)/4-0.01;
        CGFloat H = (whiteView.width*0.88 - 3*speace)/4*(140/116.00);
        return CGSizeMake(W, H);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, whiteView.width*0.06, 5, whiteView.width*0.06);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return speace;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return speace;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(whiteView.width*0.9, whiteView.width*26/66.00);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(whiteView.width*0.9, 60);
}
-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:199/255.0 blue:18/255.0 alpha:1];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, whiteView.width, whiteView.width*26/66.00)];
        imgView.image = [UIImage imageNamed:@"logFirst_headerImg"];
        imgView.userInteractionEnabled = YES;
        [view addSubview:imgView];
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(imgView.width-30, 0, 30, 30);
        [btn addTarget:self action:@selector(cancelLQ) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:btn];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(imgView.width/3, imgView.height/2, imgView.width/3, 24)];
        title.layer.cornerRadius = 12;
        title.layer.masksToBounds = YES;
        title.backgroundColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:11];
        title.textColor = [UIColor whiteColor];
        title.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"已连续签到"),logDayCount,YZMsg(@"天")];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        
    }else{
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        //view.backgroundColor =[UIColor grayColor];
        UIButton *receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = whiteView.width*0.8;
        CGFloat btnH = 30;
        CGFloat btnX = whiteView.width*0.1;
        CGFloat btnY = 15;
        receiveBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        receiveBtn.backgroundColor = normalColors;
        [receiveBtn addTarget:self action:@selector(clickReceiveBtn) forControlEvents:UIControlEventTouchUpInside];
        [receiveBtn setTitle:YZMsg(@"立即签到") forState:UIControlStateNormal];
        receiveBtn.titleLabel.textColor = [UIColor whiteColor];
        receiveBtn.layer.cornerRadius = 15;
        receiveBtn.layer.masksToBounds = YES;
        receiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:receiveBtn];
        
    }
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zi",indexPath.item);
}
- (void)cancelLQ{
    [self.delegate removeView:nil];
}
/******************  <- 登录奖励  ********************/




@end
