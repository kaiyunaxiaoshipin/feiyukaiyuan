//
//  TiStickerManager.h
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TiStickerItem.h"

/**
 Sticker operation management class
 */
@interface TiStickerManager : NSObject

+ (instancetype)sharedManager;

/**
 Whether through the network load stickers
 */
@property(nonatomic, assign) BOOL isLoadStickersFromServer;

/**
 Asynchronous mode reads all the sticker information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadStickersWithCompletion:(void (^)(NSMutableArray<TiSticker *> *stickers))completion;

/*
 * Get the sticker path
 */
- (NSString *)getStickerPath;

/**
 Update StickerConfig's sticker download status
 */
- (void)updateConfigJSON;

/**
 Update the Json file and get new Json
 */
- (NSMutableDictionary *)updateConfigJSONForDic;

/**
 Update the json file of local stickers from the server
 completion:After the completion of the block of callback  {【isSuccess：Whether the update is successful】，【dic：The updated new json】}
 serverJson:The new stickers array from the server
 */
- (void)updateStickersJSONWithCompletion:(void (^)(BOOL isSuccess, NSMutableDictionary *dic))completion serverJson:(NSArray *)serverJson;


@end
