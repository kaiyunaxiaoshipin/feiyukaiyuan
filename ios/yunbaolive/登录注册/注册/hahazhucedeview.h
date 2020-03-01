#import <UIKit/UIKit.h>
@interface hahazhucedeview : UIViewController



- (IBAction)doBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneT;


@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaT;

@property (weak, nonatomic) IBOutlet UITextField *passWordT;

@property (weak, nonatomic) IBOutlet UITextField *password2;

- (IBAction)doRegist:(id)sender;
- (IBAction)getYanZheng:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *yanzhengmaBtn;

@property (weak, nonatomic) IBOutlet UIButton *registBTn;

@end
