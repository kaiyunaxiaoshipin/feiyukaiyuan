#import "redCar.h"
#import "UIButton+WebCache.h"
#define carWidth  _window_width/1.5
#define carHeight  _window_height/1.5
@interface redCar ()
{
    UIImageView *carImage1;
    UIImageView *carImage2;
    UIImageView *carImage3;
    UIImageView *carImage4;
    UIImageView *carImage5;
    UIImageView *carImage6;
    UIView *buttomView;
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    NSMutableArray *array4;
    NSMutableArray *array5;
    NSMutableArray *array6;
}
@end
@implementation redCar
-(instancetype)initWithIcons:(NSString *)icons andName:(NSString *)name{
    self = [super init];
    if (self) {
        carImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage1.contentMode = UIViewContentModeScaleAspectFit;
        carImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage2.contentMode = UIViewContentModeScaleAspectFit;
        carImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage3.contentMode = UIViewContentModeScaleAspectFit;
        carImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage4.contentMode = UIViewContentModeScaleAspectFit;
        carImage5 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage5.contentMode = UIViewContentModeScaleAspectFit;
        carImage6 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,carWidth,carHeight)];
        carImage6.contentMode = UIViewContentModeScaleAspectFit;
        carImage2.hidden = YES;
        carImage3.hidden = YES;
        carImage4.hidden = YES;
        carImage5.hidden = YES;
        carImage6.hidden = YES;
        array1=[NSMutableArray array];
        array2=[NSMutableArray array];
        array3=[NSMutableArray array];
        array4=[NSMutableArray array];
        array5=[NSMutableArray array];
        array6=[NSMutableArray array];
        for (int j=0; j<5; j++) {
            NSString *imageName=[NSString stringWithFormat:@"car--%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            if (image != nil) {
                [array1 addObject:image];
            }
        }
        //要展示的动画
        carImage1.animationImages=array1;
        //一次动画的时间
        carImage1.animationDuration=[array1 count]*0.008;
        //只执行一次动画
        carImage1.animationRepeatCount = MAXFLOAT;
        //开始动画
        [carImage1 startAnimating];
        //释放内存
        /*
        [carImage performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:[array count]*0.1];
        */
        buttomView = [[UIView alloc]initWithFrame:CGRectMake(_window_width,20,carWidth,carHeight)];
        [buttomView addSubview:carImage1];
        [buttomView addSubview:carImage2];
        [buttomView addSubview:carImage3];
        [buttomView addSubview:carImage4];
        [buttomView addSubview:carImage5];
        [buttomView addSubview:carImage6];
        
        
        CGFloat w = 40;
        UIButton *iconBTN1 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN1.backgroundColor = [UIColor whiteColor];
        iconBTN1.frame = CGRectMake(carImage1.center.x,carImage1.center.y - w, w, w);
        [iconBTN1 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN1.layer.masksToBounds = YES;
        iconBTN1.layer.cornerRadius = w/2;
        iconBTN1.layer.borderWidth = 1;
        iconBTN1.layer.borderColor = normalColors.CGColor;
        
        
        UILabel *nameL1 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN1.frame.origin.x, iconBTN1.frame.origin.y + w , 200, 20)];
        nameL1.textColor = normalColors;
        nameL1.backgroundColor = [UIColor clearColor];
        nameL1.text = [NSString stringWithFormat:@"%@",name];
        nameL1.textAlignment = NSTextAlignmentLeft;
        
        
        [carImage1 addSubview:nameL1];
        UIButton *iconBTN2 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN2.backgroundColor = [UIColor whiteColor];
        iconBTN2.frame = CGRectMake(carImage2.center.x,carImage2.center.y - w, w, w);
        [iconBTN2 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN2.layer.masksToBounds = YES;
        iconBTN2.layer.cornerRadius = w/2;
        iconBTN2.layer.borderWidth = 1;
        iconBTN2.layer.borderColor = normalColors.CGColor;
        
        
        
        UILabel *nameL2 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN2.frame.origin.x, iconBTN2.frame.origin.y + w , 200, 20)];
        nameL2.textColor = normalColors;
        nameL2.backgroundColor = [UIColor clearColor];
        nameL2.text = [NSString stringWithFormat:@"%@",name];
        nameL2.textAlignment = NSTextAlignmentLeft;
        [carImage2 addSubview:nameL2];

        
        
        UIButton *iconBTN3 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN3.backgroundColor = [UIColor whiteColor];
        iconBTN3.frame = CGRectMake(carImage3.center.x,carImage3.center.y - w, w, w);
        [iconBTN3 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN3.layer.masksToBounds = YES;
        iconBTN3.layer.cornerRadius = w/2;
        iconBTN3.layer.borderWidth = 1;
        iconBTN3.layer.borderColor = normalColors.CGColor;
        
        UILabel *nameL3 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN3.frame.origin.x, iconBTN3.frame.origin.y + w , 200, 20)];
        nameL3.textColor = normalColors;
        nameL3.backgroundColor = [UIColor clearColor];
        nameL3.text = [NSString stringWithFormat:@"%@",name];
        nameL3.textAlignment = NSTextAlignmentLeft;
        
        
        [carImage3 addSubview:nameL3];
        
        
        UIButton *iconBTN4 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN4.backgroundColor = [UIColor whiteColor];
        iconBTN4.frame = CGRectMake(carImage4.center.x,carImage4.center.y - w, w, w);
        [iconBTN4 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN4.layer.masksToBounds = YES;
        iconBTN4.layer.cornerRadius = w/2;
        iconBTN4.layer.borderWidth = 1;
        iconBTN4.layer.borderColor = normalColors.CGColor;
        
        UILabel *nameL4 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN4.frame.origin.x, iconBTN4.frame.origin.y + w , 200, 20)];
        nameL4.textColor = normalColors;
        nameL4.backgroundColor = [UIColor clearColor];
        nameL4.text = [NSString stringWithFormat:@"%@",name];
        nameL4.textAlignment = NSTextAlignmentLeft;
        
        [carImage4 addSubview:nameL4];
        
        UIButton *iconBTN5 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN5.backgroundColor = [UIColor whiteColor];
        iconBTN5.frame = CGRectMake(carImage5.center.x,carImage5.center.y - w, w, w);
        [iconBTN5 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN5.layer.masksToBounds = YES;
        iconBTN5.layer.cornerRadius = w/2;
        iconBTN5.layer.borderWidth = 1;
        iconBTN5.layer.borderColor = normalColors.CGColor;
        
        UILabel *nameL5 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN5.frame.origin.x, iconBTN5.frame.origin.y + w , 200, 20)];
        nameL5.textColor = normalColors;
        nameL5.backgroundColor = [UIColor clearColor];
        nameL5.text = [NSString stringWithFormat:@"%@",name];
        nameL5.textAlignment = NSTextAlignmentLeft;
        
        [carImage5 addSubview:nameL5];
        
        UIButton *iconBTN6 = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBTN6.backgroundColor = [UIColor whiteColor];
        iconBTN6.frame = CGRectMake(carImage6.center.x,carImage6.center.y - w, w, w);
        [iconBTN6 sd_setBackgroundImageWithURL:[NSURL URLWithString:icons] forState:UIControlStateNormal];
        iconBTN6.layer.masksToBounds = YES;
        iconBTN6.layer.cornerRadius = w/2;
        iconBTN6.layer.borderWidth = 1;
        iconBTN6.layer.borderColor = normalColors.CGColor;
        
        UILabel *nameL6 = [[UILabel alloc]initWithFrame:CGRectMake(iconBTN6.frame.origin.x, iconBTN6.frame.origin.y + w , 200, 20)];
        nameL6.textColor = normalColors;
        nameL6.backgroundColor = [UIColor clearColor];
        nameL6.text = [NSString stringWithFormat:@"%@",name];
        nameL6.textAlignment = NSTextAlignmentLeft;
        
        [carImage6 addSubview:nameL6];
        [carImage1 addSubview:iconBTN1];
        [carImage2 addSubview:iconBTN2];
        [carImage3 addSubview:iconBTN3];
        [carImage4 addSubview:iconBTN4];
        [carImage5 addSubview:iconBTN5];
        [carImage6 addSubview:iconBTN6];
        
        [self addSubview:buttomView];
        
        [self donghua];
        
        }
    return self;
}
-(void)donghua{

    [UIView animateWithDuration:1.0 animations:^{
        buttomView.frame = CGRectMake(_window_width/3,_window_height*0.1,carWidth,carHeight);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [carImage1 removeFromSuperview];
        carImage2.hidden = NO;
        array2=[NSMutableArray array];
        for (int j=0; j<10; j++) {
            NSString *imageName=[NSString stringWithFormat:@"car--%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array2 addObject:image];
        }
        //要展示的动画
        carImage2.animationImages=array2;
        //一次动画的时间
        carImage2.animationDuration=[array2 count]*0.02;
        //只执行一次动画
        carImage2.animationRepeatCount = 3;
        //开始动画
        [carImage2 startAnimating];
        carImage3.hidden = NO;
       
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [carImage2 removeFromSuperview];
        array3=[NSMutableArray array];
        for (int j=0; j<5; j++) {
            NSString *imageName=[NSString stringWithFormat:@"car--%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array3 addObject:image];
        }
        //要展示的动画
        carImage3.animationImages=array3;
        //一次动画的时间
        carImage3.animationDuration=[array3 count]*0.008;
        //只执行一次动画
        carImage3.animationRepeatCount =MAXFLOAT;
        //开始动画
        [carImage3 startAnimating];
        [UIView animateWithDuration:2.5 animations:^{
            buttomView.frame = CGRectMake(-_window_width,_window_height*0.15,carWidth,carHeight);
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [carImage3 removeFromSuperview];
        carImage4.hidden = NO;
        for (int j=0; j<5; j++) {
            NSString *imageName=[NSString stringWithFormat:@"car_%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array4 addObject:image];
        }
        //要展示的动画
        carImage4.animationImages=array4;
        //一次动画的时间
        carImage4.animationDuration=[array4 count]*0.008;
        //只执行一次动画
        carImage4.animationRepeatCount = MAXFLOAT;
        //开始动画
        [carImage4 startAnimating];
        buttomView.frame = CGRectMake(_window_width, _window_height*0.4, carWidth, carHeight);
        
        [UIView animateWithDuration:2.0 animations:^{
            buttomView.frame = CGRectMake(_window_width/5,_window_height*0.2,carWidth,carHeight);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [carImage4 removeFromSuperview];
            carImage5.hidden = NO;
            for (int j=0; j<10; j++) {
                NSString *imageName=[NSString stringWithFormat:@"car_%d.png",j+1];
                NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
                UIImage *image=[UIImage imageWithContentsOfFile:path];
                [array5 addObject:image];
            }
            //要展示的动画
            carImage5.animationImages=array5;
            //一次动画的时间
            carImage5.animationDuration=[array5 count]*0.02;
            //只执行一次动画
            carImage5.animationRepeatCount = 3;
            //开始动画
            [carImage5 startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                carImage6.hidden = NO;
                [carImage5 removeFromSuperview];
                for (int j=0; j<5; j++) {
                    NSString *imageName=[NSString stringWithFormat:@"backCar%d.png",j+1];
                    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
                    UIImage *image=[UIImage imageWithContentsOfFile:path];
                    [array6 addObject:image];
                }
                //要展示的动画
                carImage6.animationImages=array6;
                //一次动画的时间
                carImage6.animationDuration=[array6 count]*0.008;
                //只执行一次动画
                carImage6.animationRepeatCount = MAXFLOAT;
                //开始动画
                [carImage6 startAnimating];
                [UIView animateWithDuration:1.5 animations:^{
                    buttomView.frame = CGRectMake(-carWidth,-carHeight,carWidth,carHeight);
                }];
            });
        });
    });
}
@end
