//
//  JCHATMessageContentView.m
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageContentView.h"
#import "JChatConstants.h"
#import <QMapKit/QMapKit.h>

static NSInteger const textMessageContentTopOffset = 10;
static NSInteger const textMessageContentRightOffset = 15;

@interface JCHATMessageContentView()
{
    QMapView *_mapView;
}

@end

@implementation JCHATMessageContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self attachTapHandler];
        
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _textContent = [UILabel new];
        _textContent.numberOfLines = 0;
        _textContent.textColor = [UIColor whiteColor];
        _textContent.backgroundColor = [UIColor clearColor];
        
        _infoL = [UILabel new];
        _infoL.numberOfLines = 0;
        _infoL.textColor = [UIColor whiteColor];
        _infoL.backgroundColor = [UIColor clearColor];
        _infoL.font = SYS_Font(13);
        
        _voiceConent = [UIImageView new];
        _isReceivedSide = NO;
        
        _mapIV = [[UIImageView alloc]init];
        [self addSubview:_mapIV];
        
        _imageViewAnntation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //NSString *b_path = [[NSBundle mainBundle]pathForResource:@"QMapKit.bundle" ofType:nil];
        //NSString *img_path = [b_path stringByAppendingPathComponent:@"images/greenPin_lift.png"];
        //_imageViewAnntation.image = [UIImage imageWithContentsOfFile:img_path];
        _imageViewAnntation.image = [UIImage imageNamed:@"location_current"];
        _imageViewAnntation.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageViewAnntation];
        
        [self addSubview:_textContent];
        [self addSubview:_infoL];
        [self addSubview:_voiceConent];
        
        _mapView = [[QMapView alloc]init];
        _mapView.zoomEnabled = NO;
        [_mapView setShowsUserLocation:NO];
        [_mapView setShowsScale:NO];
        [_mapView setScrollEnabled:NO];
        
    }
    return self;
}
- (void)setMessageContentWith:(JMSGMessage *)message{
    [self setMessageContentWith:message handler:nil];
}
- (void)setMessageContentWith:(JMSGMessage *)message handler:(void (^)(NSUInteger))block {
    BOOL isReceived = [message isReceived];
    _message = message;
    UIImageView *maskView = nil;
    UIImage *maskImage = nil;
    if (isReceived) {
        maskImage = [UIImage imageNamed:@"chat_bg_other"];
        //发送地理位置要求背景色为白色
        if (message.contentType == kJMSGContentTypeLocation) {
            maskImage = [UIImage imageNamed:@"chat_bg_location_other"];
        }
        _textContent.textColor = RGB_COLOR(@"#333333", 1);

    } else {
        maskImage = [UIImage imageNamed:@"chat_bg_my"];
        if (message.contentType == kJMSGContentTypeLocation) {
            maskImage = [UIImage imageNamed:@"chat_bg_location_my"];
        }
        _textContent.textColor = [UIColor whiteColor];

    }
    //maskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    maskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)];

    [self setImage:maskImage];
    maskView = [UIImageView new];
    maskView.image = maskImage;
    [maskView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.layer.mask = maskView.layer;
    self.contentMode = UIViewContentModeScaleToFill;
    
    _textContent.textAlignment = NSTextAlignmentLeft;
    switch (message.contentType) {
        case kJMSGContentTypeText:{
            _voiceConent.hidden = YES;
            _textContent.hidden = NO;
            _infoL.hidden = YES;
            _mapIV.hidden = YES;
            _imageViewAnntation.hidden = YES;
            if (isReceived) {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            } else {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            }
            _textContent.text = ((JMSGTextContent *)message.content).text;
            
            //匹配表情文字
            NSString *pattern = @"\\[\\w+\\]";
            NSArray *resultArr =   [self machesWithPattern:pattern andStr:_textContent.text];
            if (!resultArr) return;
            NSUInteger lengthDetail = 0;
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:_textContent.text];
            //遍历所有的result 取出range
            for (NSTextCheckingResult *result in resultArr) {
                //取出图片名
                NSString *imageName =   [_textContent.text substringWithRange:NSMakeRange(result.range.location, result.range.length)];
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
            //更新到label上
            _textContent.attributedText = attstr;
        }break;
            
        case kJMSGContentTypeImage: {
            _voiceConent.hidden = YES;
            _textContent.hidden = YES;
            _infoL.hidden = YES;
            _mapIV.hidden = YES;
            _imageViewAnntation.hidden = YES;
            self.contentMode = UIViewContentModeScaleAspectFill;
            [(JMSGImageContent *)message.content thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
                if (error == nil) {
                    if (data != nil) {
                        [self setImage:[UIImage imageWithData:data]];
                    } else {
                        [self setImage:[UIImage imageNamed:@"receiveFail"]];
                    }
                } else {
                    [self setImage:[UIImage imageNamed:@"receiveFail"]];
                }
                if (block) {
                    NSData *imageData = UIImagePNGRepresentation(self.image);
                    block(imageData.length);
                }
            }];
        }break;
        case kJMSGContentTypeVoice: {
            _textContent.hidden = YES;
            _infoL.hidden = YES;
            _voiceConent.hidden = NO;
            _mapIV.hidden = YES;
            _imageViewAnntation.hidden = YES;
            if (isReceived) {//height = 50
                [_voiceConent setFrame:CGRectMake(20, 15, 20, 20)];
                [_voiceConent setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
            } else {
                [_voiceConent setFrame:CGRectMake(self.frame.size.width - 40, 15, 20, 20)];
                [_voiceConent setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
            }
            [((JMSGVoiceContent *)message.content) voiceData:^(NSData *data, NSString *objectId, NSError *error) {
                if (error == nil) {
                    if (block) {
                        block(data.length);
                    }
                } else {
                    DDLogDebug(@"get message voiceData fail with error %@",error);
                }
            }];
        }break;
        case kJMSGContentTypeFile: {
            _voiceConent.hidden = YES;
            _textContent.hidden = NO;
            _infoL.hidden = YES;
            _mapIV.hidden = YES;
            _imageViewAnntation.hidden = YES;
            self.contentMode = UIViewContentModeScaleAspectFit;
            [self setImage:[UIImage imageNamed:@"file_message_bg"]];
            
            JMSGFileContent *fileContent = (JMSGFileContent *)message.content;
            _textContent.text = fileContent.fileName;
            _textContent.textAlignment = NSTextAlignmentRight;
            if (isReceived) {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            } else {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            }
        }break;
        case kJMSGContentTypeLocation: {
            _voiceConent.hidden = YES;
            _textContent.hidden = NO;
            _infoL.hidden = NO;
            _mapIV.hidden = NO;
            _imageViewAnntation.hidden = NO;
            self.contentMode = UIViewContentModeScaleAspectFit;
            //[self setImage:[UIImage imageNamed:@"location_address"]];
            
            JMSGLocationContent *locationContent = (JMSGLocationContent *)message.content;
            
            NSData *mix_data = [locationContent.address dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *mix_dic = [NSJSONSerialization JSONObjectWithData:mix_data options:NSJSONReadingAllowFragments error:nil];
            if ([mix_dic isKindOfClass:[NSDictionary class]]) {
                _textContent.text = [NSString stringWithFormat:@"%@",[mix_dic valueForKey:@"name"]];
                _infoL.text = [NSString stringWithFormat:@"%@",[mix_dic valueForKey:@"info"]];
            }else {
                _textContent.text = locationContent.address;
            }
            _textContent.textColor  = RGB_COLOR(@"#323232", 1);
            _infoL.textColor = RGB_COLOR(@"#646464", 1);
            
            if (isReceived) {
                self.backgroundColor = RGB_COLOR(@"#ffffff", 1);//RGB(44, 42, 62);
                
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, 20)];
                [_infoL setFrame:CGRectMake(textMessageContentRightOffset + 5, _textContent.bottom, self.frame.size.width - 2 * textMessageContentRightOffset, 15)];
            } else {
                self.backgroundColor = RGB_COLOR(@"#fbd946", 1);//RGB_COLOR(@"#ffffff", 1);
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, 20)];
                [_infoL setFrame:CGRectMake(textMessageContentRightOffset - 5, _textContent.bottom, self.frame.size.width - 2 * textMessageContentRightOffset, 15)];
            }
            [_mapIV setFrame:CGRectMake(0, _infoL.bottom, self.width, self.height-textMessageContentTopOffset-35)];
            [_mapView setFrame:CGRectMake(0, _infoL.bottom, self.width, self.height-textMessageContentTopOffset-35)];
            CLLocationCoordinate2D center;
            center.latitude = [locationContent.latitude doubleValue];
            center.longitude = [locationContent.longitude doubleValue];
            [_mapView setCenterCoordinate:center zoomLevel:16.01 animated:NO];
            [_mapView takeSnapshotInRect:_mapView.bounds withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
                [_mapIV setImage:resultImage];
            }];

            _imageViewAnntation.center = _mapView.center;
            
        }break;
        case kJMSGContentTypeUnknown:
            _voiceConent.hidden = YES;
            _textContent.hidden = NO;
            _mapIV.hidden = YES;
            _imageViewAnntation.hidden = YES;
            if (isReceived) {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            } else {
                [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
            }
            _textContent.text = st_receiveUnknowMessageDes;
            break;
        default:
            break;
    }
    
}

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str
{
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error)
    {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)attachTapHandler{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.minimumPressDuration = 1.0;
    [self addGestureRecognizer:touch];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_message.contentType == kJMSGContentTypeVoice) {
        return action == @selector(delete:);
    }
    return (action == @selector(copy:) || action == @selector(delete:));
}

-(void)copy:(id)sender {
    __block UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    switch (_message.contentType) {
        case kJMSGContentTypeText:
        {
            JMSGTextContent *textContent = (JMSGTextContent *)_message.content;
            pboard.string = textContent.text;
        }
            break;
            
        case kJMSGContentTypeImage:
        {
            JMSGImageContent *imgContent = (JMSGImageContent *)_message.content;
            [imgContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
                if (data == nil || error) {
                    UIWindow *myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    //[MBProgressHUD showMessage:@"获取图片错误" view:myWindow];
                    [MBProgressHUD showMessage:@"获取图片错误" toView:myWindow];
                    return ;
                }
                pboard.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case kJMSGContentTypeVoice:
            break;
        case kJMSGContentTypeUnknown:
            break;
        default:
            break;
    }
    
}

-(void)delete:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteMessage object:_message];
}
@end
