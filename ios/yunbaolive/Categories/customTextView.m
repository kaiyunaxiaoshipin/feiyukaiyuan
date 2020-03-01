

#import "customTextView.h"

@implementation customTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        
        self.autoresizesSubviews = NO;
        self.placeholder = YZMsg(@"给直播写个标题吧");
        self.placeholderColor = RGB(227, 226, 226);
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect

{
    //内容为空时才绘制placeholder
    
     if ([self.text isEqual:@""]) {
        CGRect placeholderRect;
        placeholderRect.origin.y = 8;
        
        placeholderRect.origin.x = self.center.x*0.5;
        placeholderRect.size.height = CGRectGetHeight(self.frame)-8;
        placeholderRect.size.width = CGRectGetWidth(self.frame)-5;
        
                [self.placeholderColor set];
        [self.placeholder drawInRect:placeholderRect
                            withFont:self.font
                       lineBreakMode:NSLineBreakByWordWrapping
                           alignment:NSTextAlignmentLeft];
        
    }
    
}

- (void)textChanged:(NSNotification *)not
{
    
    [self setNeedsDisplay];
    
}
- (void)setText:(NSString *)text
{
    
    [super setText:text];
    [self setNeedsDisplay];
    
}

@end
