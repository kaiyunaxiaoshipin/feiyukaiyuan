//
//  videoMoreView.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "videoMoreView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"

@interface videoMoreView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat collectionvh;
    MBProgressHUD *hud;
    NSURL *fullPathsss;
    
    UIColor *text_corlor;
    UIColor *bg_corlor;
    
    
}
@property(nonatomic,strong)NSDictionary *hostdic;
@property(nonatomic,strong)NSArray *itemarray;
@property(nonatomic,strong)UICollectionView *colelction;
@end
@implementation videoMoreView
-(instancetype)initWithFrame:(CGRect)frame andHostDic:(NSDictionary *)dic cancleblock:(xinxinblock)block delete:(xinxinblock)deleteblock share:(xinxinblock)share{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteblock = deleteblock;
        self.cancleblock = block;
        self.shareblock = share;
        
        text_corlor = RGB(92, 92, 101);
        bg_corlor = [UIColor whiteColor];
        
        _hostdic = [NSDictionary dictionaryWithDictionary:dic];
        
        _itemarray = [NSArray arrayWithArray:[common share_type]];
        
        //没有分享
        if (_itemarray.count==0) {
            collectionvh = frame.size.height-30-ShowDiff;//(_window_height/2.8 - 50)/2;
        }else{
            collectionvh = (frame.size.height-30-ShowDiff)/2;
        }
        
        //取消
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 50)];
        topView.backgroundColor = [UIColor clearColor];
        [self addSubview:topView];
        UILabel *shareL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _window_width*0.6, 30)];
        shareL.text = [NSString stringWithFormat:YZMsg(@"分享至")];
        shareL.textColor = text_corlor;
        shareL.font = SYS_Font(15);
        [topView addSubview:shareL];
        UIButton *canclebtn = [UIButton buttonWithType:0];
//        [canclebtn setTitle:YZMsg(@"取消") forState:0];
//        [canclebtn setTitleColor:[UIColor blackColor] forState:0];
        [canclebtn setImage:[UIImage imageNamed:@"video_close"] forState:0];
        canclebtn.frame = CGRectMake(_window_width-60,0, 50, 50);
        [canclebtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//        [topView addSubview:canclebtn];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flow.itemSize = CGSizeMake(_window_width/4, collectionvh);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;

        
        _colelction = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, _window_width,collectionvh) collectionViewLayout:flow];
        _colelction.delegate = self;
        _colelction.dataSource = self;
        [_colelction registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"videoMore"];
        _colelction.alwaysBounceHorizontal = YES;
        [self addSubview:_colelction];
        _colelction.backgroundColor = bg_corlor;//RGB(20, 19, 43);
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.layer.mask = maskLayer;
        
        NSString *ID = [NSString stringWithFormat:@"%@",[[_hostdic valueForKey:@"userinfo"] valueForKey:@"id"]];
//        NSArray *array = @[@"举报",@"复制",YZMsg(@"拉黑"),YZMsg(@"保存")];
        NSArray *array = @[@"复制链接",@"举报",YZMsg(@"保存")];
#warning 是自己的视频未处理
        if ([ID isEqual:[Config getOwnID]]) {
            array =@[@"复制链接",YZMsg(@"删除"),YZMsg(@"保存")];
        }
        //如果没有分享
        CGFloat btny = collectionvh+30;
        if (_itemarray.count == 0) {
            _colelction.frame = CGRectMake(0, 0, 0, 0);
            btny = 30;
        }
        CGFloat btnx = 0;
        CGFloat btnw = _window_width/4;
        for (int i=0; i<array.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(btnx, btny, btnw, collectionvh);
            [btn setImage:[UIImage imageNamed:array[i]] forState:0];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(makeaction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btnx+=btnw;
            
            //点击事件
            [btn setTitleColor:[UIColor clearColor] forState:0];
            [btn setTitle:array[i] forState:0];
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
        self.backgroundColor =bg_corlor; //RGB(20, 19, 43);
    }
    return self;
}
-(void)makeaction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqual:YZMsg(@"拉黑")]) {
        [self setBlack:sender];
    }else if ([sender.titleLabel.text isEqual:@"举报"]) {
        [self jubao];
    }else if ([sender.titleLabel.text isEqual:@"复制链接"]) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"href"]];
        [MBProgressHUD showSuccess:YZMsg(@"复制成功")];
    }else if ([sender.titleLabel.text isEqual:YZMsg(@"保存")]) {
        [self downloadVideo:sender];
    }else if ([sender.titleLabel.text isEqual:YZMsg(@"删除")]) {
        UIViewController *currentVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认删除?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        YBWeakSelf;
        UIAlertAction *suerA = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deletemovie:sender];
        }];
        UIAlertAction *cnacelA = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.deleteblock(@"取消删除");
        }];
        [alertC addAction:cnacelA];
        [alertC addAction:suerA];
        [currentVC presentViewController:alertC animated:YES completion:nil];
        
    }
}
//下载视频到本地
-(void)downloadVideo:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    sender.userInteractionEnabled = YES;
        
    });
    NSString *href = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"href"]];
    if ([href containsString:@"qiniu"]) {
        href = [NSString stringWithFormat:@"%@?ref=support.qiniu.com",href];
    }
    NSString *title = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"title"]];
    if (title.length == 0) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
        title = timeString;
    }
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在下载视频";
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:href];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        hud.progress = downloadProgress.fractionCompleted;
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        fullPathsss = filePath;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager fileExistsAtPath:[filePath path]];

       NSLog(@"%@ ----%d",filePath,result);

        
    UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
    }];
    
    //3.执行Task
    [download resume];
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error == nil) {
    NSLog(@"视频保存成功");
    hud.labelText = @"视频保存成功";
    }else{
    NSLog(@"视频保存失败");
    hud.labelText = @"频保存失败";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
     BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:[fullPathsss path] error:nil];
    NSLog(@"%d",isOk);
}
- (void)save:(NSString*)urlString{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:urlString]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"Save video fail:%@",error);
                                    } else {
                                        NSLog(@"Save video succeed.");
                                    }
                                }];
}
-(void)cancel{
    self.cancleblock(NULL);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemarray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoMore" forIndexPath:indexPath];
    CGFloat width = _window_width * 132 /750;
    UIImageView *imagevc = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width/8-width/2,collectionvh/2-width/2,width,width)];
    [imagevc setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish_%@",_itemarray[indexPath.row]]]];
    imagevc.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imagevc];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *fenxiang = _itemarray[indexPath.row];
    
    if ([fenxiang isEqual:@"qzone"]) {
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }
    else if([fenxiang isEqual:@"qq"])
    {
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }
    else if([fenxiang isEqual:@"wx"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatSession];
    }
    else if([fenxiang isEqual:@"wchat"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
    }
    else if([fenxiang isEqual:@"facebook"])
    {
        [self simplyShare:SSDKPlatformTypeFacebook];
    }
    else if([fenxiang isEqual:@"twitter"])
    {
        [self simplyShare:SSDKPlatformTypeTwitter];
    }
}
//分享
-(void)FenXiang:(NSDictionary *)dic{
    NSString *fenxiang = [dic valueForKey:@"fenxiang"];
    if ([fenxiang isEqual:@"qzone"]) {
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }
    else if([fenxiang isEqual:@"qq"])
    {
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }
    else if([fenxiang isEqual:@"wx"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatSession];
    }
    else if([fenxiang isEqual:@"wchat"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
    }
    else if([fenxiang isEqual:@"facebook"])
    {
        [self simplyShare:SSDKPlatformTypeFacebook];
    }
    else if([fenxiang isEqual:@"twitter"])
    {
        [self simplyShare:SSDKPlatformTypeTwitter];
    }
}
- (void)simplyShare:(int)SSDKPlatformType
{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    int SSDKContentType = SSDKContentTypeAuto;
    NSURL *ParamsURL;

//        NSString *titles = [_hostdic valueForKey:@"title"];
//
//        if (titles.length == 0) {
//            titles = [common video_share_title];
//        }
//
        ParamsURL = [NSURL URLWithString:[h5url stringByAppendingFormat:@"/index.php?g=appapi&m=video&a=index&videoid=%@&type=0",[_hostdic valueForKey:@"id"]]];
    
    
        [shareParams SSDKSetupShareParamsByText:[common video_share_des]
                                         images:[_hostdic valueForKey:@"thumb_s"]
                                            url:ParamsURL
                                          title:[common video_share_title]
                                           type:SSDKContentType];
    
    __weak videoMoreView *weakself = self;
    //进行分享
    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showSuccess:YZMsg(@"分享成功")];
                 [weakself addShare];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showError:YZMsg(@"分享失败")];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
}
//举报
-(void)jubao{
    
    if (self.jubaoBlock) {
        self.jubaoBlock([_hostdic valueForKey:@"id"]);
    }

    
}
//拉黑
-(void)setBlack:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.setBlack&uid=%@&token=%@&videoid=%@",[Config getOwnID],[Config getOwnToken],[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            [MBProgressHUD showSuccess:YZMsg(@"拉黑成功")];
            //刷新外部列表
            NSString *videoIDStr = [NSString stringWithFormat:@"%@",[weakSelf.hostdic valueForKey:@"id"]];
            NSDictionary *dic = @{
                                  @"videoid":videoIDStr,
                                  };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:dic];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.deleteblock(videoIDStr);
            });
        }else if ([code isEqual:@"700"]){
            [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];

        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}
//删除
-(void)deletemovie:(UIButton *)sender{
     sender.userInteractionEnabled = NO;
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.del"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"videoid":[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]
                             };
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:subdic Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            [MBProgressHUD showSuccess:@"删除成功"];
            //刷新外部列表
            NSString *videoIDStr = [NSString stringWithFormat:@"%@",[weakSelf.hostdic valueForKey:@"id"]];
            NSDictionary *dic = @{
                                  @"videoid":videoIDStr,
                                  };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:dic];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.deleteblock(videoIDStr);
            });
        }else if ([code isEqual:@"700"]){
            [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}
-(void)addShare{
    NSString *random_str = [PublicObj stringToMD5:[NSString stringWithFormat:@"%@-%@-#2hgfk85cm23mk58vncsark",[Config getOwnID],[_hostdic valueForKey:@"id"]]];
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.addShare&uid=%@&videoid=%@&random_str=%@",[Config getOwnID],[_hostdic valueForKey:@"id"],random_str];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            weakSelf.shareblock([NSString stringWithFormat:@"%@",[info valueForKey:@"shares"]]);
        }else if ([code isEqual:@"700"]){
             [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
    

}

@end
