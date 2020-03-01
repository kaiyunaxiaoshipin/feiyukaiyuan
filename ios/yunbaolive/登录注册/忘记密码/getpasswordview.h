#import <UIKit/UIKit.h>

@interface getpasswordview : UIViewController



@property (weak, nonatomic) IBOutlet UITextField *phoneT;

@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;

- (IBAction)clickYanzhengma:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengmaBtn;

@property (weak, nonatomic) IBOutlet UITextField *secretT;

@property (weak, nonatomic) IBOutlet UILabel *secretT2;
@property (weak, nonatomic) IBOutlet UITextField *secretTT2;
@property (weak, nonatomic) IBOutlet UIButton *findNowBtn;
- (IBAction)clickFindBtn:(id)sender;

@end
