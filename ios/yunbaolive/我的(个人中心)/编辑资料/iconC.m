#import "iconC.h"
#import "Utils.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIButton+WebCache.h"
@interface iconC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString  *filePath;
    NSURL *imageURL;
    int setvisicon;
}
@property (weak, nonatomic) IBOutlet UIButton *iconBTN;
- (IBAction)paizhao:(id)sender;
- (IBAction)xiangce:(id)sender;
- (IBAction)fanhui:(id)sender;
- (IBAction)iconBTNNNN:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *paizhaob;
@property (weak, nonatomic) IBOutlet UIButton *xiangceb;
@end
@implementation iconC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LiveUser *user = [[LiveUser alloc] init];
    user =  [Config myProfile];
    NSURL *url = [NSURL URLWithString:user.avatar];
    [self.iconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    self.iconBTN.enabled = NO;
    
    self.iconBTN.layer.masksToBounds = YES;
    self.iconBTN.layer.cornerRadius = _window_width*0.8/2;
    self.paizhaob.layer.masksToBounds = YES;
    self.paizhaob.layer.cornerRadius = 15;
    self.xiangceb.layer.masksToBounds = YES;
    self.xiangceb.layer.cornerRadius = 15;    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisicon = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisicon = 0;
}
- (IBAction)paizhao:(id)sender {
    
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    imagePickerController.showsCameraControls = YES;
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
   // imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)xiangce:(id)sender {
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
   // imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, @"/image.png"];
        
        imageURL = [NSURL URLWithString:filePath];
        
       /*
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.labelText = @"正在上传头像";
        */
        //UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [purl stringByAppendingFormat:@"?service=User.updateAvatar&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
        
        
        
        [session POST:url parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (image) {
                [formData appendPartWithFileData:[Utils compressImage:image] name:@"file" fileName:@"duibinaf.png" mimeType:@"image/jpeg"];
            }
        }
         
              progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                  //NSLog(@"%@",responseObject);
                  NSLog(@"-------%@",responseObject);
                  NSArray *data = [responseObject valueForKey:@"data"];
                  NSString *ret = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"]];
                  if ([ret isEqual:@"200"]) {
                      
                 
                  NSNumber *number = [data valueForKey:@"code"] ;
                  if([number isEqualToNumber:[NSNumber numberWithInt:0]])
                  {
                      
//                      [[SDImageCache sharedImageCache] clearDisk];
                      [[SDImageCache sharedImageCache] clearMemory];//可有可无
                      
                      NSString *info = [[data valueForKey:@"info"] firstObject];
                      NSString *avatar = [info valueForKey:@"avatar"];
                      NSString *avatar_thumb = [info valueForKey:@"avatar_thumb"];
                      [self.iconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal];
                      LiveUser *user = [[LiveUser alloc]init];
                      user.avatar = avatar;
                      user.avatar_thumb = avatar_thumb;
                      
                      [Config updateProfile:user];
                      
                      
                  }
                       }
                  else{
                      [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
                  }
              }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             //NSLog(@"-------%@",error);
             [MBProgressHUD showError:YZMsg(@"上传失败")];
             
             
         }];
        
         [picker dismissViewControllerAnimated:YES completion:nil];


       
    }
}
- (IBAction)fanhui:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)iconBTNNNN:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

@end
