//
//  MAClient.h
//  SocketDemo
//
//  Created by nwk on 2016/12/16.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAMessage.h"
#import "MAResponseSocket.h"


@interface MAClient : NSObject

@property (assign, nonatomic) int sessionId;//会话ID
@property (strong, nonatomic) NSArray *agents;//客服资料

+ (instancetype)sharedMAClient;
/**
 *  初始化SDK
 *
 *  @param serverAddr 服务器地址
 *  @param wsAddr     webSocket地址
 */
+ (void)initializeClient:(NSString *)serverAddr;

- (void)contentRyTokenService:(NSString *)userId nickName:(NSString *)nickName protrait:(NSString *)portraitUri complete:(void (^)(BOOL result))complete;
/**
 *  获取当前的客服资料
 *
 *  @param agentId 客服ID
 *
 *  @return 客服资料
 */
- (MAAgent *)getCurrentAgent:(NSString *)agentId;

/**
 *  发送排队请求
 *
 */
- (NSString *)createQueuedRequestJson:(int)queue;
/**
 *  取消排队请求
 *
 *  @param requestId 排队号
 */
- (void)cancelQueuedRequest:(int)requestId;

/**
 *  发送消息
 *
 *  @param msg        文字
 */
- (NSString *)createMessageJsonStr:(MAMessage *)msg;
@end
