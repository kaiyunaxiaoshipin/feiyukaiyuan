//
//  TiStickerDownloadManager.m
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import "TiStickerDownloadManager.h"
#import "TiStickerItem.h"
#import "SSZipArchive.h"
#import "TiStickerManager.h"
#import "TiConst.h"
#import "TiSDKInterface.h"

@interface TiStickerDownloader : NSObject <SSZipArchiveDelegate, NSURLSessionDelegate>
@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, copy) void (^successedBlock)(TiSticker *, NSInteger, TiStickerDownloader *);

@property(nonatomic, copy) void (^failedBlock)(TiSticker *, NSInteger, TiStickerDownloader *);

@property(nonatomic, strong) TiSticker *sticker;

@property(nonatomic, strong) NSURL *url;

@property(nonatomic, assign) NSInteger index;

- (instancetype)initWithSticker:(TiSticker *)sticker url:(NSURL *)url index:(NSInteger)index;

- (void)downloadSuccessed:(void (^)(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader))success failed:(void (^)(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader))failed;

@end

@implementation TiStickerDownloader

- (instancetype)initWithSticker:(TiSticker *)sticker url:(NSURL *)url index:(NSInteger)index {
    if (self = [super init]) {

        self.sticker = sticker;
        self.index = index;
        self.url = url;
    }

    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session =
                [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (void)downloadSuccessed:(void (^)(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader))success failed:(void (^)(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader))failed {

    [[self.session downloadTaskWithURL:self.url completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        if (error) {
            failed(self.sticker, self.index, self);
        } else {
            self.successedBlock = success;
            self.failedBlock = failed;
            // unzip
            [SSZipArchive unzipFileAtPath:location.path toDestination:[[TiStickerManager sharedManager] getStickerPath] delegate:self];

        }
    }] resume];

}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];

        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - Unzip complete callback

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    // update sticker's download config
    [[TiStickerManager sharedManager] updateConfigJSON];

    NSString *dir =
            [NSString stringWithFormat:@"%@/%@/", [[TiStickerManager sharedManager] getStickerPath], self.sticker.stickerName];
    NSURL *url = [NSURL fileURLWithPath:dir];

    NSString *s =
            [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img.jpeg"];

    [TiSticker updateStickerAfterDownload:self.sticker DirectoryURL:url sucess:^(TiSticker *sucessSticker) {

        self.successedBlock(sucessSticker, self.index, self);

    }                                fail:^(TiSticker *failSticker) {

        self.failedBlock(failSticker, self.index, self);

    }];

}

@end

@interface TiStickerDownloadManager ()

/**
 *   操作缓冲池
 */
@property(nonatomic, strong) NSMutableDictionary *downloadCache;

@end

@implementation TiStickerDownloadManager

+ (instancetype)sharedInstance {
    static id _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [TiStickerDownloadManager new];
    });

    return _sharedManager;
}

- (NSMutableDictionary *)downloadCache {
    if (_downloadCache == nil) {
        _downloadCache = [[NSMutableDictionary alloc] init];
    }
    return _downloadCache;
}

- (void)downloadSticker:(TiSticker *)sticker index:(NSInteger)index withAnimation:(void (^)(NSInteger index))animating successed:(void (^)(TiSticker *sticker, NSInteger index))success failed:(void (^)(TiSticker *sticker, NSInteger index))failed {
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", sticker.stickerName];

    NSURL *downloadUrl = sticker.downloadURL;

    if (sticker.sourceType == TiStickerSourceTypeFromTi) {

        downloadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [TiSDK getStickerURL], zipName]];
    }

    // 判断是否存在对应的下载操作
    if (self.downloadCache[downloadUrl] != nil) {
        return;
    }

    animating(index);

    TiStickerDownloader *downloader = [[TiStickerDownloader alloc] initWithSticker:sticker url:downloadUrl index:index];

    [self.downloadCache setObject:downloader forKey:downloadUrl];

    [downloader downloadSuccessed:^(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader) {

        [self.downloadCache removeObjectForKey:downloadUrl];
        downloader = nil;
        success(sticker, index);

    }                      failed:^(TiSticker *sticker, NSInteger index, TiStickerDownloader *downloader) {

        [self.downloadCache removeObjectForKey:downloadUrl];
        downloader = nil;
        failed(sticker, index);

    }];

}

- (void)downloadStickers:(NSArray *)stickers withAnimation:(void (^)(NSInteger index))animating successed:(void (^)(TiSticker *sticker, NSInteger index))success failed:(void (^)(TiSticker *sticker, NSInteger index))failed {

    for (TiSticker *sticker in stickers) {
        if (sticker.isDownload == NO && sticker.downloadState == TiStickerDownloadStateDownoadNot) {
            sticker.downloadState = TiStickerDownloadStateDownoading;
            dispatch_async(dispatch_get_main_queue(), ^{

                [self downloadSticker:sticker index:[stickers indexOfObject:sticker] withAnimation:^(NSInteger index) {

                    animating([stickers indexOfObject:sticker]);

                }           successed:^(TiSticker *sticker, NSInteger index) {
                    success(sticker, index);

                }              failed:^(TiSticker *sticker, NSInteger index) {
                    failed(sticker, index);

                }];

            });
        }
    }
}


@end
