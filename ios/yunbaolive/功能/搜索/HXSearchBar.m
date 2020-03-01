

#import "HXSearchBar.h"

@implementation HXSearchBar
//设置输入框光标颜色
- (void)setCursorColor:(UIColor *)cursorColor
{
    if (cursorColor) {
        _cursorColor = cursorColor;
        
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        UIImageView *searchImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
        searchImageV.image = [UIImage imageNamed:@"searchBar"];
        searchField.leftView = searchImageV;
        if (searchField) {
            //光标颜色
            [searchField setTintColor:cursorColor];
        }
    }
}
//获取输入框
- (UITextField *)searchBarTextField
{
    //获取输入框
    _searchBarTextField = [self valueForKey:@"searchField"];
    return _searchBarTextField;
}

//设置清除按钮图标
- (void)setClearButtonImage:(UIImage *)clearButtonImage
{
    if (clearButtonImage) {
        _clearButtonImage = clearButtonImage;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //设置清除按钮图片
            UIButton *button = [searchField valueForKey:@"_clearButton"];
            [button setImage:clearButtonImage forState:UIControlStateNormal];
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
}

- (void)setHideSearchBarBackgroundImage:(BOOL)hideSearchBarBackgroundImage {
    if (hideSearchBarBackgroundImage) {
        _hideSearchBarBackgroundImage = hideSearchBarBackgroundImage;
        self.backgroundImage = [[UIImage alloc] init];
    }
}

//获取取消按钮
- (UIButton *)cancleButton
{
    self.showsCancelButton = YES;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            _cancleButton = (UIButton *)view;
        }
    }
    return _cancleButton;
}

@end
