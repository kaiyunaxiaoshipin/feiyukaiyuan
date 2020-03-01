//
//  JCHATChatModel.m
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import "JCHATChatModel.h"
#import "JChatConstants.h"
#import "JCHATStringUtils.h"
#define headHeight 46

static NSInteger const voiceBubbleHeight = 50;

@implementation JCHATChatModel
- (instancetype)init {
  self = [super init];
  if (self) {
    _isTime = NO;
  }
  return self;
}

- (void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation userModel:(MessageListModel *)userModel {
    
  _message = message;
  _messageTime = message.timestamp;
    
    //用户 id 和 头像 使用业务服务器的信息
    if (_message.isReceived) {
        _uidStr = userModel.uidStr;
        _uiconStr = userModel.iconStr;
    }else {
        _uidStr = [Config getOwnID];
        _uiconStr = [Config getavatarThumb];
    }
    
  switch (message.contentType) {
    case kJMSGContentTypeUnknown:
    {
      if (message.content == nil) {
        [self getTextHeight];
      }
    }
      break;
    case kJMSGContentTypeText:
    {
      [self getTextHeight];
    }
      break;
    case kJMSGContentTypeImage:
    {
      [self setupImageSize];
    }
          break;
          
    case kJMSGContentTypeFile:{
        if (self.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
            _contentSize = CGSizeMake(77, 57);
            return;
        }
        self.imageSize = CGSizeMake(215, 67);
        _contentSize = CGSizeMake(217, 67);
    }
          break;
    case kJMSGContentTypeLocation:
    {
        if (self.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
            _contentSize = CGSizeMake(77, 57);
            return;
        }
        self.imageSize = CGSizeMake(217+20, 136+35);
        _contentSize = CGSizeMake(217+20, 136+35);
    }
      break;
    case kJMSGContentTypeVoice:
    {
      [self setupVoiceSize:((JMSGVoiceContent *)message.content).duration];
    }
      break;
    case kJMSGContentTypeEventNotification:
    {
    }
      break;
    default:
      break;
  }
  
  [self getTextHeight];
}

- (void)setErrorMessageChatModelWithError:(NSError *)error{
  _isErrorMessage = YES;
  _messageError = error;
  [self getTextSizeWithString:st_receiveErrorMessageDes];
}

- (float)getTextHeight {
  switch (self.message.contentType) {
    case kJMSGContentTypeUnknown:
    {
      [self getTextSizeWithString:st_receiveUnknowMessageDes];
    }
      break;
    case kJMSGContentTypeText:
    {
        
        [self getTextSizeWithString:((JMSGTextContent *)self.message.content).text];
       
    } break;
    case kJMSGContentTypeImage:
    {
    }
      break;
    case kJMSGContentTypeVoice:
    {
    }
      break;
    case kJMSGContentTypeEventNotification:
    {
//      [self getTextSizeWithString:[((JMSGEventContent *)self.message.content) showEventNotification]];
      [self getNotificationWithString:[((JMSGEventContent *)self.message.content) showEventNotification]];
    }
      break;
    default:
      break;
  }
  
  return self.contentHeight;
}

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str {
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}


- (CGSize)getTextSizeWithString:(NSString *)string {
  CGSize maxSize = CGSizeMake(200, 2000);
  UIFont *font =[UIFont systemFontOfSize:18];
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  
    
    //筛选表情，计算尺寸
    NSString *imStr = ((JMSGTextContent *)self.message.content).text;
    
    if (imStr) {
        //过渡Label用于计算size
        UILabel *imLabel = [[UILabel alloc]init];
        imLabel.font = SYS_Font(18);
        imLabel.numberOfLines = 0;
        imLabel.size = maxSize;
        //匹配表情文字
        NSString *pattern = @"\\[\\w+\\]";
        NSArray *resultArr =   [self machesWithPattern:pattern andStr:imStr];
        if(resultArr) {
            NSUInteger lengthDetail = 0;
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:imStr];
            //遍历所有的result 取出range
            for (NSTextCheckingResult *result in resultArr) {
                //取出图片名
                NSString *imageName =   [imStr substringWithRange:NSMakeRange(result.range.location, result.range.length)];
                NSLog(@"--------%@",imageName);
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                UIImage *emojiImage = [UIImage imageNamed:imageName];
                NSAttributedString *imageString;
                if (emojiImage) {
                    attach.image = emojiImage;
                    attach.bounds = CGRectMake(0, -5, 21, 21);
                    imageString =   [NSAttributedString attributedStringWithAttachment:attach];
                }else{
                    imageString =   [[NSMutableAttributedString alloc]initWithString:imageName];
                }
                //图片附件的文本长度是1
                NSLog(@"emoj===%zd===size-w:%f==size-h:%f",imageString.length,imageString.size.width,imageString.size.height);
                NSUInteger length = attstr.length;
                NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
                [attstr replaceCharactersInRange:newRange withAttributedString:imageString];
                lengthDetail += length - attstr.length;
            }
            imLabel.attributedText = attstr;
            [imLabel sizeToFit];
            realSize = imLabel.frame.size;
        }
    }
    
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    _contentSize = imgSize;
    _contentHeight = imgSize.height;
    
  return imgSize;
}

- (CGSize)getNotificationWithString:(NSString *)string {
  CGSize notiSize= [JCHATStringUtils stringSizeWithWidthString:string withWidthLimit:280 withFont:[UIFont systemFontOfSize:14]];
  _contentHeight = notiSize.height;
  _contentSize = notiSize;
  return notiSize;
}

- (void)setupImageSize {
  if (self.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
    _contentSize = CGSizeMake(77, 57);
    return;
  }
  
    JMSGImageContent *imageContent = (JMSGImageContent *)self.message.content;
    float imgHeight;
    float imgWidth;
    
    if (imageContent.imageSize.height >= imageContent.imageSize.width) {
        imgHeight = 135;
        imgWidth = (imageContent.imageSize.width/imageContent.imageSize.height) *imgHeight;
    } else {
        imgWidth = 135;
        imgHeight = (imageContent.imageSize.height/imageContent.imageSize.width) *imgWidth;
    }
    
    if ((imgWidth > imgHeight?imgHeight/imgWidth:imgWidth/imgHeight)<0.47) {
        self.imageSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);//
        _contentSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);
        return;
    }
    self.imageSize = CGSizeMake(imgWidth, imgHeight);
    _contentSize = CGSizeMake(imgWidth, imgHeight);
//  [((JMSGImageContent *)self.message.content) thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
//    if (error == nil) {
//      UIImage *img = [UIImage imageWithData:data];
//      float imgHeight;
//      float imgWidth;
//      
//      if (img.size.height >= img.size.width) {
//        imgHeight = 135;
//        imgWidth = (img.size.width/img.size.height) *imgHeight;
//      } else {
//        imgWidth = 135;
//        imgHeight = (img.size.height/img.size.width) *imgWidth;
//      }
//      
//      if ((imgWidth > imgHeight?imgHeight/imgWidth:imgWidth/imgHeight)<0.47) {
//        self.imageSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);//
//        _contentSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);
//        return;
//      }
//      self.imageSize = CGSizeMake(imgWidth, imgHeight);
//      _contentSize = CGSizeMake(imgWidth, imgHeight);
//    } else {
//      NSLog(@"get thumbImageData fail with error %@",error);
//    }
//  }];
}

- (float)getLengthWithDuration:(NSInteger)duration {
  NSInteger voiceBubbleWidth = 0;
  
  if (duration <= 2) {
    voiceBubbleWidth = 60;
  } else if (duration >2 && duration <=20) {
    voiceBubbleWidth = 60 + 2.5 * duration;
  } else if (duration > 20 && duration < 30){
    voiceBubbleWidth = 110 + 2 * (duration - 20);
  } else if (duration >30  && duration < 60) {
    voiceBubbleWidth = 130 + 1 * (duration - 30);
  } else {
    voiceBubbleWidth = 160;
  }
  
  _contentSize = CGSizeMake(voiceBubbleWidth, voiceBubbleHeight);
  return voiceBubbleWidth;
}

- (void)setupVoiceSize:(NSNumber *)timeduration {
  NSInteger voiceBubbleWidth = 0;
  NSInteger duration = [timeduration integerValue];
  
  if (duration <= 2) {
    voiceBubbleWidth = 60;
  } else if (duration >2 && duration <=20) {
    voiceBubbleWidth = 60 + 2.5 * duration;
  } else if (duration > 20 && duration < 30){
    voiceBubbleWidth = 110 + 2 * (duration - 20);
  } else if (duration >30  && duration < 60) {
    voiceBubbleWidth = 130 + 1 * (duration - 30);
  } else {
    voiceBubbleWidth = 160;
  }
  _contentSize = CGSizeMake(voiceBubbleWidth, voiceBubbleHeight);
}
@end
