
#import "sexCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "LiveUser.h"
#import "Config.h"
@implementation sexCell



+(sexCell *)cellWithTableView:(UITableView *)tableView{
    
    sexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"edimMySex.xib"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"edimMySex" owner:self options:nil].lastObject;
        LiveUser *user = [Config myProfile];
        
        if ([user.sex isEqualToString:@"1"]) {
            cell.imageV.image = [UIImage imageNamed:@"choice_sex_nanren"];
        }
        
        else{
            cell.imageV.image = [UIImage imageNamed:@"choice_sex_nvren"];
        }
        
    }
    
    
    return cell;
    
    
}
@end
