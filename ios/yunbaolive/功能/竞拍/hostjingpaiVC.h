//
//  hostjingpaiVC.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/29.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^axinblocks)(NSDictionary *dic);

@interface hostjingpaiVC : UIView

@property(nonatomic,strong)axinblocks blocks;

-(instancetype)initWithFrame:(CGRect)frame andblock:(axinblocks)block andjingpaiid:(NSString *)ID;

-(void)getjingpaimessage:(NSDictionary *)subdic;

-(void)addjingpairesultview:(int)a anddic:(NSDictionary *)dic;

-(void)addnowfirstpersonmessahevc;
-(void)getnewmessage:(NSDictionary *)dic;
-(void)removeall;
@end
