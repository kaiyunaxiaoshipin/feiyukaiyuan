#import "planView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#define planW  _window_width
#define planH  _window_height/2
@interface planView ()
{
    UIImageView *planeView1;
    UIView *buttomView;
    UIImageView *showImage;
    NSMutableArray *array1;
    NSTimer *timerLabel;
}
@end
//用来销毁花朵
static int f = 1000;
static int g = 2000;
@implementation planView
-(instancetype)initWithicon:(NSString *)icons andName:(NSString *)name{
    self = [super init];
    if (self) {
        array1 = [NSMutableArray array];
        planeView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,planW,planH)];
        planeView1.contentMode = UIViewContentModeScaleAspectFit;
        showImage = [[UIImageView alloc]initWithFrame:CGRectMake(100,150,planW/2,planH/4)];
        showImage.contentMode = UIViewContentModeScaleAspectFit;
        showImage.image= [UIImage imageNamed:@"plane_shadow.png"];
        [planeView1 addSubview:showImage];
        buttomView = [[UIView alloc]initWithFrame:CGRectMake(_window_width,0,planW, planH)];
        UIButton *iconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN.backgroundColor = [UIColor whiteColor];
        CGFloat w = 40;
        iconBTN.frame = CGRectMake(planeView1.center.x,planeView1.center.y - w - 20, w, w);
        [iconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN.layer.masksToBounds = YES;
        iconBTN.layer.cornerRadius = w/2;
        iconBTN.layer.borderWidth = 1;
        iconBTN.layer.borderColor = normalColors.CGColor;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN.frame.origin.x, iconBTN.frame.origin.y + w , 200, 20)];
        nameL.textColor = normalColors;
        nameL.backgroundColor = [UIColor clearColor];
        nameL.text = [NSString stringWithFormat:@"%@",name];
        nameL.textAlignment = NSTextAlignmentLeft;
        [planeView1 addSubview:nameL];
        [planeView1 addSubview:iconBTN];
        [buttomView addSubview:planeView1];
        [self addSubview:buttomView];
        [self dodonghua];
    }
    return self;
}
-(void)dodonghua{
    
    for (int j=0; j<13; j++) {
        
        NSString *imageName=[NSString stringWithFormat:@"plan%d.png",j+1];
        NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
        UIImage *image=[UIImage imageWithContentsOfFile:path];
        [array1 addObject:image];
        
    }
    
    //要展示的动画
    planeView1.animationImages=array1;
    //一次动画的时间
    planeView1.animationDuration=[array1 count]*0.008;
    //只执行一次动画
    planeView1.animationRepeatCount = MAXFLOAT;
    //开始动画
    [planeView1 startAnimating];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        buttomView .frame=CGRectMake(0,0,planW,planH);

    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

      timerLabel =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(random) userInfo:nil repeats:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [timerLabel invalidate];
              timerLabel = nil;
            });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2.0 animations:^{
                buttomView.frame=CGRectMake(-_window_width,0,planW,planH);
             }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [buttomView removeFromSuperview];
            });
            
    });
        });
    
}
-(void)random{
    
    srand((unsigned)time(0));
    
    CGFloat randomX = (CGFloat)(arc4random()% 161)+_window_width;
    CGFloat randomY = (CGFloat)(arc4random()% 161)+_window_height;
 
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(buttomView.frame.size.width/2,buttomView.frame.size.height/2, 50, 50)];
    label2.tag = f;
    
    f+=1;

    label2.font = [UIFont systemFontOfSize:30];
    
    label2.text = @"❀";

    [self addSubview:label2];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(buttomView.frame.size.width/2 - 20,buttomView.frame.size.height/2, 50, 50)];
    label.tag = g;
    g+=1;
    label.font = [UIFont systemFontOfSize:30];
    label.text = @"❀";
    [self addSubview:label];
    label2.textColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    label.textColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    [UIView animateWithDuration:3.5 animations:^{
        label2.frame = CGRectMake(randomX,randomY, 50, 50);
        label.frame = CGRectMake(randomX,randomY, 50, 50);
    }];
    
    
}
@end
