//
//  TiStickerDownloadManager.h
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TiSticker;

@interface TiStickerDownloadManager : NSObject

+ (instancetype)sharedInstance;

/**
 Download a single sticker
 
 @param sticker the sticker to download
 @param index the index of the sticker in the array
 @param animating the animation when downloading
 @param success download successed callback
 @param failed download failed callback
 */

- (void)downloadSticker:(TiSticker *)sticker index:(NSInteger)index withAnimation:(void (^)(NSInteger index))animating successed:(void (^)(TiSticker *sticker, NSInteger index))success failed:(void (^)(TiSticker *sticker, NSInteger index))failed;

/**
 Download all unsaved stickers
 
 @param stickers the array of all stickers
 @param animating the animation when downloading
 @param success the sticker download successed
 @param failed the sticker download failed
 */

- (void)downloadStickers:(NSArray *)stickers withAnimation:(void (^)(NSInteger index))animating successed:(void (^)(TiSticker *sticker, NSInteger index))success failed:(void (^)(TiSticker *sticker, NSInteger index))failed;

@end
