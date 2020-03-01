//
//  myInfoEdit.m
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "myInfoEdit.h"
#import "InfoEdit1TableViewCell.h"
#import "InfoEdit2TableViewCell.h"
#import "EditNiceName.h"
#import "EditSignature.h"
#import "iconC.h"
#import "sexCell.h"
#import "sexChange.h"
#import "UIImageView+WebCache.h"
#import "impressVC.h"

@interface myInfoEdit ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int setvisinfo;
    UIDatePicker *datapicker;
    NSString *datestring;//保存时间
    UIAlertController *alert;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    NSArray *itemArray;
}

@end

@implementation myInfoEdit


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    
    itemArray = @[YZMsg(@"昵称"),YZMsg(@"签名"),YZMsg(@"生日"),YZMsg(@"性别"),YZMsg(@"我的主播印象")];
    
    self.view.backgroundColor = [UIColor whiteColor];
    datapicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,0, _window_width-16, _window_height*0.3)];
    
    NSDate *currentDate = [NSDate date];
    [datapicker setMaximumDate:currentDate];
    
    NSDateFormatter  * formatter = [[ NSDateFormatter   alloc ] init ];
    
    [formatter  setDateFormat : @"yyyy-MM-dd" ];
    
    NSString  * mindateStr =  @"1950-01-01" ;
    
    NSDate  * mindate = [formatter  dateFromString :mindateStr];
    
    datapicker . minimumDate = mindate;
    
    datapicker.maximumDate=[NSDate date];

    [datapicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged ];
    
    datapicker.datePickerMode = UIDatePickerModeDate;
    //设置为中文
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datapicker.locale =locale;
    NSString *alertTitle;
    if (_window_height <= 667.0) {
        alertTitle = @"\n\n\n\n\n\n\n\n\n";
    }else{
        alertTitle = @"\n\n\n\n\n\n\n\n\n\n\n\n";
    }
    
    alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert.view addSubview:datapicker];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self getbirthday];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];

    
    
}
//生日
-(void)getbirthday{
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    if (datestring == nil) {
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        datestring = [dateFormatter stringFromDate:currentDate];
        
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[datestring] forKeys:@[@"birthday"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            LiveUser *user = [[LiveUser alloc] init];
            user.birthday = datestring;
            [Config updateProfile:user];
            [self.tableView reloadData];
            
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];

    
}
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {

    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    [selectDateFormatter setDateFormat:@"YYYY-MM-dd"];
    datestring = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvisinfo = 1;
    [self.tableView reloadData];
    [self navtion];
    [self.tableView reloadData];
    self.tableView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - 64- statusbarHeight);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisinfo = 0;
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"编辑资料");
    [label setFont:navtionTitleFont];
    
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

    [self.view addSubview:navtion];
    
    
}
-(void)money{
    
    
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断返回cell
    LiveUser *users = [Config myProfile];
    if (indexPath.section == 0) {
        InfoEdit1TableViewCell *cell = [InfoEdit1TableViewCell cellWithTableView:tableView];
        cell.imgRight.layer.masksToBounds = YES;
        cell.imgRight.layer.cornerRadius = 20;
        return cell;
    }
    else
    {
        InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
        cell.labContrName.text = itemArray[indexPath.row];

        if (indexPath.row == 0) {
            cell.labDetail.text = [Config getOwnNicename];
        }
        else if(indexPath.row == 1)
        {
            cell.labDetail.text = [Config getOwnSignature];
        }
        else if (indexPath.row == 2){
            cell.labDetail.text = users.birthday;
        }
        else if (indexPath.row == 3){
            if ([users.sex isEqual:@"1"]) {
                cell.labDetail.text = YZMsg(@"男");
            }else{
                cell.labDetail.text = YZMsg(@"女");
            }
        }else{
            cell.labDetail.text = @"";
        }
        return cell;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60;
    }
    else
        
        return 50;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return 1;
    }
    else
    {
        return itemArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 2;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断返回cell
    
    if (indexPath.section == 0) {
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *picAction = [UIAlertAction actionWithTitle:YZMsg(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectThumbWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alertContro addAction:picAction];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:YZMsg(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectThumbWithType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertContro addAction:photoAction];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        
        [self presentViewController:alertContro animated:YES completion:nil];
    }
    else {
        if(indexPath.row == 0)
        {
            EditNiceName *EditNameView = [[EditNiceName alloc] init];
            [[MXBADelegate sharedAppDelegate] pushViewController:EditNameView animated:YES];
        
        }
        else if(indexPath.row == 1){
            EditSignature *EditSignatureView = [[EditSignature alloc] init];
            [[MXBADelegate sharedAppDelegate] pushViewController:EditSignatureView animated:YES];
        }
        else if (indexPath.row == 2){
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (indexPath.row == 3){
            sexChange *sex = [[sexChange alloc]init];
            [[MXBADelegate sharedAppDelegate] pushViewController:sex animated:YES];
        }
        else{
            impressVC *vc = [[impressVC alloc]init];
            vc.isAdd = NO;
            vc.touid = @"0";
            [[MXBADelegate sharedAppDelegate] pushViewController:vc animated:YES];
            
        }
    }
    
    
}
- (void)selectThumbWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = type;
    imagePickerController.allowsEditing = YES;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [MBProgressHUD showMessage:YZMsg(@"正在上传")];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil)
//        {
            data = UIImageJPEGRepresentation(image, 0.5);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
        
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [purl stringByAppendingFormat:@"?service=User.updateAvatar&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
        [session POST:url parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (image) {
                [formData appendPartWithFileData:data name:@"file" fileName:@"duibinaf.png" mimeType:@"image/jpeg"];
            }
        }
             progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                 [MBProgressHUD hideHUD];
                 NSLog(@"-------%@",responseObject);
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSString *ret = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"]];
                 if ([ret isEqual:@"200"]) {
                     
                     
                     NSNumber *number = [data valueForKey:@"code"] ;
                     if([number isEqualToNumber:[NSNumber numberWithInt:0]])
                     {
                         
                         [[SDImageCache sharedImageCache] clearMemory];//可有可无
                         NSString *info = [[data valueForKey:@"info"] firstObject];
                         NSString *avatar = [info valueForKey:@"avatar"];
                         NSString *avatar_thumb = [info valueForKey:@"avatar_thumb"];
                         LiveUser *user = [[LiveUser alloc]init];
                         user.avatar = avatar;
                         user.avatar_thumb = avatar_thumb;
                         
                         [Config updateProfile:user];
                         [self.tableView reloadData];
                         [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                     }
                 }
                 else{
                     [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
                 }
             }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             //NSLog(@"-------%@",error);
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:YZMsg(@"上传失败")];
             
             
         }];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
