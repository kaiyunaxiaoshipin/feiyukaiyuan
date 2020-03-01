//
//  SearchResultView.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#define SearchResultGetPoiSearchResult @"SearchResultGetPoiSearchResult"

#import <UIKit/UIKit.h>

#import <QMapSearchKit/QMapSearchKit.h>

typedef void (^ResultVDismissBlock)(QMSPoiData* reult);

@interface SearchResultView : UIView

@property (nonatomic, strong)void(^searchResultsPage)(NSInteger page);
@property(nonatomic,copy)ResultVDismissBlock dismissEvent;

@property (nonatomic,strong)NSMutableArray <QMSPoiData*>* dataSource;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)NSInteger pageIndex;


@end
