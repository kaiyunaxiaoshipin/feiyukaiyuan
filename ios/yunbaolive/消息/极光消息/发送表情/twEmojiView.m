//
//  twEmojiView.m
//  TaiWanEight
//
//  Created by Boom on 2017/11/23.
//  Copyright © 2017年 YangBiao. All rights reserved.
//

#import "twEmojiView.h"
#import "emojiCell.h"
@interface CollCellWhite : UICollectionViewCell

@end

@implementation CollCellWhite

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
@implementation twEmojiView{
    UICollectionView *collectionView;
    NSArray *emojiArray;
    UIPageControl *_pageControl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
        emojiArray = @[@"[微笑]",@"[色]",@"[发呆]",@"[抽烟]",@"[抠鼻]",@"[哭]",@"[发怒]",@"[呲牙]",@"[睡]",@"[害羞]",@"[调皮]",@"[晕]",@"[衰]",@"[闭嘴]",@"[指点]",@"[关注]",@"[搞定]",@"[胜利]",@"[无奈]",@"[打脸]",@"msg_del",@"[大笑]",@"[哈欠]",@"[害怕]",@"[喜欢]",@"[困]",@"[疑问]",@"[伤心]",@"[鼓掌]",@"[得意]",@"[捂嘴]",@"[惊恐]",@"[思考]",@"[吐血]",@"[卖萌]",@"[嘘]",@"[生气]",@"[尴尬]",@"[笑哭]",@"[口罩]",@"[斜眼]",@"msg_del",@"[酷]",@"[脸红]",@"[大叫]",@"[眼泪]",@"[见钱]",@"[嘟]",@"[吓]",@"[开心]",@"[想哭]",@"[郁闷]",@"[互粉]",@"[赞]",@"[拜托]",@"[唇]",@"[粉]",@"[666]",@"[玫瑰]",@"[黄瓜]",@"[啤酒]",@"[无语]",@"msg_del",@"[纠结]",@"[吐舌]",@"[差评]",@"[飞吻]",@"[再见]",@"[拒绝]",@"[耳机]",@"[抱抱]",@"[嘴]",@"[露牙]",@"[黄狗]",@"[灰狗]",@"[蓝狗]",@"[狗]",@"[脸黑]",@"[吃瓜]",@"[绿帽]",@"[汗]",@"[摸头]",@"[阴险]",@"msg_del",@"[擦汗]",@"[瞪眼]",@"[疼]",@"[鬼脸]",@"[拇指]",@"[亲]",@"[大吐]",@"[高兴]",@"[敲打]",@"[加油]",@"[吐]",@"[握手]",@"[18禁]",@"[菜刀]",@"[威武]",@"[给力]",@"[爱心]",@"[心碎]",@"[便便]",@"[礼物]",@"msg_del",@"[生日]",@"[喝彩]",@"[雷]",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"345",@"msg_del"];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    LWLCollectionViewHorizontalLayout *layout =[[LWLCollectionViewHorizontalLayout alloc]init];
    layout.itemCountPerRow = 7;
    layout.rowCount = 3;
    layout.itemSize = CGSizeMake((_window_width-20)/7, (_window_width-20)/7);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat collectinHeight = (_window_width-20)/7*3;
    collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(10,10, _window_width-20,collectinHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[CollCellWhite class] forCellWithReuseIdentifier:@"emojiWhite"];
    [collectionView registerNib:[UINib nibWithNibName:@"emojiCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"emojiCELL"];
    [self addSubview:collectionView];
    _pageControl = [[UIPageControl alloc] init];
    
    CGFloat pageSpace = (EmojiHeight - collectinHeight-20-20)/2;
    _pageControl.frame = CGRectMake(collectionView.width/2, collectionView.bottom+pageSpace, 20, 20);//指定位置大小
    //_pageControl.center.x = self.collectionView.center.x;
    
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
    _pageControl.currentPageIndicatorTintColor = normalColors; // 设置选中页的圆点颜色
    _pageControl.numberOfPages = (emojiArray.count%21==0)?(emojiArray.count/21):(emojiArray.count/21+1);
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    CGFloat sendSpace = (EmojiHeight - collectinHeight-20-30)/2;
    _sendEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendEmojiBtn.frame = CGRectMake(_window_width-70, collectionView.bottom+sendSpace, 60, 30);
    [_sendEmojiBtn setTitle:YZMsg(@"发送") forState:0];
    [_sendEmojiBtn setTitleColor:[UIColor whiteColor] forState:0];
    _sendEmojiBtn.titleLabel.font = SYS_Font(16);
    _sendEmojiBtn.backgroundColor = normalColors;
    _sendEmojiBtn.layer.masksToBounds = YES;
    _sendEmojiBtn.layer.cornerRadius = 15;
    [_sendEmojiBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendEmojiBtn];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / collectionView.frame.size.width;
    // 设置页码
    _pageControl.currentPage = page;
}

-(void)clickSendBtn {
     [self.delegate clickSendEmojiBtn];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return emojiArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"emojiCELL";
    
    //UICollectionViewCell *cell = nil;
    if (indexPath.item >= emojiArray.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojiWhite"
                                                                               forIndexPath:indexPath];
        return cell;
        
    } else {
        
        emojiCell *cell = (emojiCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifierCell
                                                                               forIndexPath:indexPath];
        cell.emojiImgView.image = [UIImage imageNamed:emojiArray[indexPath.row]];
        return cell;
        
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([emojiArray[indexPath.row] isEqualToString:@"345"]) {
        return;
    }
    [self.delegate sendimage:emojiArray[indexPath.row]];
}
@end
