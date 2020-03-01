//
//  MusicCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MusicCell.h"
#import "MusicModel.h"

@interface MusicCell()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *musicData;
    long long allLength;
    float currentLength;
}

@end
@implementation MusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _startRecoedBtn.layer.cornerRadius = 5;
    _startRecoedBtn.layer.masksToBounds = YES;
    _startRecoedBtn.backgroundColor = Pink_Cor;
    /** 撑起开拍按钮以上80像素高度，避免cell点击事件改变cell高度时cell内部控件变形 */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(MusicCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
   MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MusicCell" owner:nil options:nil]objectAtIndex:0];
//        cell.useBtn.layer.borderWidth = 1;
//        cell.useBtn.layer.borderColor = Pink_Cor.CGColor;
//        cell.useBtn.layer.masksToBounds = YES;
//        cell.useBtn.layer.cornerRadius = 13;
    }
    return cell;
}
- (void)setModel:(MusicModel *)model{
    
    _model = model;
    _songID = _model.songID;
    _path = _model.urlStr;
    [_bgIV sd_setImageWithURL:[NSURL URLWithString:_model.bgStr]];
    _musicNameL.text = _model.musicNameStr;
    _singerL.text = _model.singerStr;
    _timeL.text = _model.timeStr;
    if ([_model.isCollectStr isEqual:@"1"]) {
        [_useBtn setImage:[UIImage imageNamed:@"music_collect"] forState:0];
    }else{
        [_useBtn setImage:[UIImage imageNamed:@"music_uncollect"] forState:0];
    }
    [_StateBtn setImage:[UIImage imageNamed:@"music_play"] forState:0];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",_model.musicNameStr,_model.singerStr,_model.timeStr,_model.songID];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:loadPath]) {
//        NSURL *url = [NSURL URLWithString:_path];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [NSURLConnection connectionWithRequest:request delegate:self];
//       
//    }
//        [self.useBtn setTitle:@"使用" forState:UIControlStateNormal];
    
}
- (IBAction)clickUseBtn:(UIButton *)sender {
    
    //收藏按钮
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.collectMusic&uid=%@&token=%@&musicid=%@",[Config getOwnID],[Config getOwnToken],_model.songID];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            
            NSDictionary *infoDic = [[data valueForKey:@"info"]firstObject];
            NSString *isCollect = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"iscollect"]];
            if ([isCollect isEqual:@"1"]) {
                [_useBtn setImage:[UIImage imageNamed:@"music_collect"] forState:0];
            }else{
                [_useBtn setImage:[UIImage imageNamed:@"music_uncollect"] forState:0];
            }
            [_useBtn.imageView.layer addAnimation:[PublicObj originToBigToSmallRecovery] forKey:nil];
            
            [MBProgressHUD showError:msg];
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:msg];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];

}

- (IBAction)clickStartRecordBtn:(UIButton *)sender {
    _startRecoedBtn.backgroundColor = RGB_COLOR(@"#da2c72", 1);
    self.recordEvent(@"");
}

-(void)musicDownLoad{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",_model.musicNameStr,_model.singerStr,_model.timeStr,_model.songID];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:loadPath]) {
        //下载
        NSURL *url = [NSURL URLWithString:_path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        return;
    }else{
        //选择
    }
}
//接收到服务器响应的时候开始调用这个方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    musicData = [NSMutableData data];
    allLength = [response expectedContentLength];//返回服务器链接数据的有效大小
}
//开始进行数据传输的时候执行这个方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   
    [musicData appendData:data];
    currentLength += data.length;
    NSString *string = [NSString stringWithFormat:@"%.f%%",(currentLength/allLength)*100];
    
}
//数据传输完成的时候执行这个方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"已经完成数据的接收-------------");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *boxPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",_model.musicNameStr,_model.singerStr,_model.timeStr,_model.songID];
    if([musicData writeToFile:boxPath atomically:YES]){
        NSLog(YZMsg(@"保存成功"));
        //下载事件
        self.rsEvent(@"sucess",@"");
    }else{
        //下载事件
        self.rsEvent(@"fail",@"save fail");
        NSLog(@"保存失败");
    }
   
}
//数据传输错误的时候执行这个方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"请求错误的时候  %@",[error localizedDescription]);
    //下载事件
    self.rsEvent(@"fail",[NSString stringWithFormat:@"%@",[error localizedDescription]]);
    NSLog(@"保存失败");
}


@end
