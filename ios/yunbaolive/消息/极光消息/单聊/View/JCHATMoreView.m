//
//  JPIMMore.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATMoreView.h"
#import "JChatConstants.h"
#import "ViewUtil.h"
@implementation JCHATMoreView


- (void)drawRect:(CGRect)rect {
  
}

- (IBAction)photoBtnClick:(id)sender {
  
  if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
    [self.delegate photoClick];
  }
}
- (IBAction)cameraBtnClick:(id)sender {
  if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
    [self.delegate cameraClick];
  }
}


- (IBAction)clickVoiceInputBtn:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(voiceInputClick)]) {
        [self.delegate voiceInputClick];
    }
    
}

- (IBAction)clickLoactionBtn:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(locationClick)]) {
        [self.delegate locationClick];
    }
    
}


@end


@implementation JCHATMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
      
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
    self.frame = CGRectMake(0, 0, _window_width, kMoreHeight);
    self.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
  _moreView = NIB(JCHATMoreView);
  
  _moreView.frame =CGRectMake(0, 0, _window_width, kMoreHeight);
  _moreView.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    _moreView.tupianL.text = YZMsg(@"图片");
    _moreView.weizhiL.text = YZMsg(@"位置");
    _moreView.paisheL.text = YZMsg(@"拍摄");
    _moreView.yuyinL.text = YZMsg(@"语音输入");

//    _moreView.photoBtn = [PublicObj setUpImgDownText:_moreView.photoBtn space:15];
//    _moreView.cameraBtn = [PublicObj setUpImgDownText:_moreView.cameraBtn space:15];
////    _moreView.voiceInputBtn = [PublicObj setUpImgDownText:_moreView.voiceInputBtn space:15];
//    _moreView.locationBtn = [PublicObj setUpImgDownText:_moreView.locationBtn space:15];
//    CGFloat totalH = _moreView.voiceInputBtn.imageView.frame.size.height + _moreView.voiceInputBtn.titleLabel.frame.size.height;
//    CGFloat spaceH = 15;
//    //设置按钮图片偏移
//    [_moreView.voiceInputBtn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - _moreView.voiceInputBtn.imageView.frame.size.height),0.0, 0.0, -_moreView.voiceInputBtn.titleLabel.frame.size.width)];
//    //设置按钮标题偏移
//    [_moreView.voiceInputBtn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -_moreView.voiceInputBtn.imageView.frame.size.width - 15, -(totalH - _moreView.voiceInputBtn.titleLabel.frame.size.height),0.0)];

  //  [_toolbar drawRect:_toolbar.frame];
  
  //  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:_moreView];
}

@end

