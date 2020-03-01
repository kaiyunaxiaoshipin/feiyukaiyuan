#import <UIKit/UIKit.h>
@interface PhoneLoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *passWordT;
@property (weak, nonatomic) IBOutlet UIButton *doLoginBtn;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;



- (IBAction)mobileLogin:(id)sender;
- (IBAction)regist:(id)sender;
- (IBAction)forgetPass:(id)sender;
- (IBAction)clickBackBtn:(UIButton *)sender;


@end
