//
//  MAMessage.h
//  SocketDemo
//
//  Created by nwk on 2016/12/16.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMessage : NSObject

@property (assign, nonatomic) int type;
@property (strong, nonatomic) id content;
/**
 *  纯文本
 *
 *  @param msg 消息
 *
 *  @return 消息对象
 */
+ (MAMessage *)createTxtObject:(NSString *)msg;
/**
 *  发送图片
 *  @param name 图片名字
 *  @param url 图片服务器地址
 *
 *  @return 消息对象
 */
+ (MAMessage *)createImageObject:(NSString *)name url:(NSString *)url;

/**
 *  发送文件
 *  @param name 文件名字
 *  @param url 文件服务器地址
 *
 *  @return 消息对象
 */
+ (MAMessage *)createFileObject:(NSString *)name url:(NSString *)url;

/**
 *  发送定位
 *
 *  @return 消息对象
 */
+ (MAMessage *)createLocationObject:(NSString *)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude;

/**
 *  发送录音
 *
 *  @return 消息对象
 */
+ (MAMessage *)createRecordObject:(NSString *)url length:(float)lenght;
@end
