
#import "hunyinCell.h"
#import "hunyinModel.h"

#import "Config.h"
static NSString *musicPath;
@interface hunyinCell ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

{
    NSMutableData *musicData;
    long long allLength;
    float currentLength;
    
}

@end

@implementation hunyinCell

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(15,15, _window_width - 80,20)];
        
        self.nameL.textAlignment = NSTextAlignmentLeft;
        self.nameL.textColor = normalColors;
        self.nameL.font = fontMT(15);
        [self.contentView addSubview:self.nameL];
        
        self.songL = [[UILabel alloc]initWithFrame:CGRectMake(15,35, _window_width - 80,30)];
        self.songL.font = fontMT(13);
        self.songL.textAlignment = NSTextAlignmentLeft;
        self.songL.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.songL];
        self.downBTN = [UIButton buttonWithType:UIButtonTypeSystem];
        self.downBTN.frame = CGRectMake(_window_width - 70,15,40,40);
        self.downBTN.layer.masksToBounds = YES;
        self.downBTN.layer.cornerRadius = 20;
        self.downBTN.layer.borderColor = normalColors.CGColor;
        self.downBTN.layer.borderWidth = 1;
        [self.downBTN setTitleColor:normalColors forState:UIControlStateNormal];
        [self.downBTN setTitle:YZMsg(@"下载") forState:UIControlStateNormal];
        [self.downBTN addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        self.downBTN.enabled = NO;
        [self.contentView addSubview:self.downBTN];
        self.downL = [[UILabel alloc]initWithFrame:CGRectMake(_window_width - 70,15,40,40)];
        self.downL.textAlignment = NSTextAlignmentCenter;
        self.downL.layer.masksToBounds = YES;
        self.downL.layer.cornerRadius = 20;
        self.downL.layer.borderColor = normalColors.CGColor;
        self.downL.layer.borderWidth = 1;
        self.downL.font =  fontMT(13);
        self.downL.textColor = normalColors;
        self.downL.hidden = YES;
        [self.contentView addSubview:self.downL];
    }
    return self;
}


-(void)setModel:(hunyinModel *)model{
    _model = model;
    _songID = _model.songid;
    _nameL.text = _model.songname;
    _songL.text = _model.artistname;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/%@*%@*%@.mp3",_model.songid,_model.songname,_model.artistname];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:loadPath]) {
        NSURL *url = [NSURL URLWithString:self.path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        [self.downBTN setTitle:YZMsg(@"选择") forState:UIControlStateNormal];
        self.downBTN.hidden = NO;
        self.downL.hidden = YES;
    }
    else {
        if (!_isDown) {
            [self.downBTN setTitle:YZMsg(@"下载") forState:UIControlStateNormal];
        }
    }
}
+(hunyinCell *)cellWithTableView:(UITableView *)tableView{
    
    hunyinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    
    if(!cell){
        
      cell = [[hunyinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"music"];
    }
    
    return cell;
    
}

- (void)prepareForReuse

{
    
    [super prepareForReuse];
    
}



- (IBAction)download:(id)sender {

}

-(void)musicDownLoad{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/%@*%@*%@.mp3",_model.songid,_model.songname,_model.artistname];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:loadPath]) {
        NSURL *url = [NSURL URLWithString:self.path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        self.downBTN.hidden = YES;
        self.downL.hidden = NO;
        return;
    }
        else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[loadPath,_model.songid] forKeys:@[@"music",@"lrc"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wangminxindemusicplay" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancle" object:nil];
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
//    NSString *string = [[NSString stringWithFormat:@"%f",(currentLength/allLength)] substringToIndex:3];
    NSString *string = [NSString stringWithFormat:@"%d",(int)(currentLength*100/allLength)];

    NSString *string2 = [string stringByAppendingPathComponent:@"%"];
    self.downL.text = string2;
}
 //数据传输完成的时候执行这个方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"已经完成数据的接收-------------");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    musicPath = [docDir stringByAppendingFormat:@"/%@*%@*%@.mp3",_model.songid,_model.songname,_model.artistname];
    if([musicData writeToFile:musicPath atomically:YES]){
        NSLog(YZMsg(@"保存成功"));
    }else{
        NSLog(@"保存失败");
    }
    
    /*
    NSLog(@"%@*******************",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/audio.mp3"]);
     */
     [self.downBTN setTitle:YZMsg(@"选择") forState:UIControlStateNormal];
     self.downBTN.hidden = NO;
     self.downL.hidden = YES;
     self.isDown = NO;
}

//数据传输错误的时候执行这个方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"请求错误的时候  %@",[error localizedDescription]);
    
}
-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:@"wangminxindemusicplay"];
//    [[NSNotificationCenter defaultCenter]removeObserver:@"cancle"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wangminxindemusicplay" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancle" object:nil];


}
@end
