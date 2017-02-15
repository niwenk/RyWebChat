//
//  MAEliteChat.h
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAEliteChat : NSObject

/**
 * 初始化EliteChat， 并且启动聊天
 * @param serverAddr EliteWebChat服务地址
 * @param userId 用户登录id
 * @param name 用户名
 * @param portraitUri 用户头像uri
 * @param queueId 排队队列号
 * @param complete 回调
 */
+ (instancetype)initAndStart:(NSString *)serverAddr userId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)portraitUri queueId:(int)queueId complete:(void (^)(BOOL result))complete;
/**
 * 初始化EliteChat
 * @param serverAddr EliteWebChat服务地址
 * @param userId 用户登录id
 * @param name 用户名
 * @param portraitUri 用户头像uri
 * @param complete 回调
 */
+ (instancetype)initElite:(NSString *)serverAddr userId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)portraitUri complete:(void (^)(BOOL result))complete;
/**
 * 启动聊天
 * @param complete 回调
 * @param queueId 排队队列号
 */
+ (void)startChat:(int)queueId complete:(void (^)())complete;
@end
