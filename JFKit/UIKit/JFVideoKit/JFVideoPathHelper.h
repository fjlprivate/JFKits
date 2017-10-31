//
//  JFVideoPathHelper.h
//  JFMediaDemo
//
//  Created by JohnnyFeng on 2017/10/23.
//  Copyright © 2017年 JohnnyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

# define JFVideoDirectoryName   @"JFVideoDirectory"  // 视频在document目录下的子目录名

@interface JFVideoPathHelper : NSObject

// 当前时间的视频全路径:(Document/yyyyMMddHHmmss.mp4)
+ (NSString*) videoPathForCurTime;

// 存放视频的目录:(Document)
+ (NSString*) videoPathForSaving;

// 视频目录下的所有视频名字集
+ (NSDirectoryEnumerator*) allVideoNamesInDisk;

// 删除指定url的视频文件
+ (void) removeVideoWithURL:(NSURL*)url;

// 清理视频目录(暂时不删除相册中的视频)
+ (void) clearAllVideosInDisk;

// 保存视频到相册(在当前app名称的目录下面)
+ (void) savingVideoIntoAlbumWithURL:(NSURL*)url completionHandler:(void (^) (BOOL success, NSError* error))completionHandler;



@end
