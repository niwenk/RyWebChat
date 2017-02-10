//
//  MAClient.m
//  SocketDemo
//
//  Created by nwk on 2016/12/16.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import "MAClient.h"
#import "MJExtension.h"
#import "MAFNetworkingTool.h"
#import "MAClientConfig.h"
#import <RongIMKit/RongIMKit.h>
#import "MAHttpService.h"

@interface MAClient()


@property (strong, nonatomic) NSString *serverAddress;//服务器地址
@property (readwrite, nonatomic) NSString *tokenStr;

@end

@implementation MAClient

#define HTTPPATH @"tpi"
#define UPLOADPATH @"tpiu"

static MAClient *client;
+ (instancetype)sharedMAClient {
	
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[MAClient alloc] init];
        client.sessionId = -1;
    });
    
    return client;
}
/**
 *  初始化SDK
 *
 *  @param serverAddr 服务器地址
 *  @param wsAddr     webSocket地址
 */
+ (void)initializeClient:(NSString *)serverAddr {
    if (!client) [MAClient sharedMAClient];
    
    if (isMAEmpty(serverAddr)) NSLog(@"sdk初始化失败:服务器地址地址为空！");
    
    client.serverAddress = serverAddr;
}
- (void)contentRyTokenService:(NSString *)userId nickName:(NSString *)nickName protrait:(NSString *)portraitUri complete:(void (^)(BOOL result))complete  {
    
    if (isMAEmpty(self.serverAddress)) return complete(NO);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"login";
    dic[@"userId"] = userId;
    dic[@"name"] = nickName;
    dic[@"portraitUri"] = portraitUri;
    
    [MAHttpService getRyToken:self.serverAddress paramer:dic success:^(NSString *token) {
        
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"---%@",userId);
            
            [self loginSuccess:@"张三" userId:userId portrait:@"" token:token];
            
            self.tokenStr = token;
            
            complete(YES);
            
        } error:^(RCConnectErrorCode status) {
            //TODO 获取token失败
            
            NSLog(@"---%zd",status);
            complete(NO);
            
        } tokenIncorrect:^{
            [self contentRyTokenService:userId nickName:nickName protrait:portraitUri complete:complete];
        }];
        
    } error:^(NSError *error) {
        NSLog(@"error:%@",error);
        complete(NO);
    }];
}

- (void)loginSuccess:(NSString *)userName
              userId:(NSString *)userId
            portrait:(NSString *)portraitUri
               token:(NSString *)token {
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                     name:userName
                                                 portrait:portraitUri];
    
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
    [RCIM sharedRCIM].currentUserInfo = user;
}

- (MAAgent *)getCurrentAgent:(NSString *)agentId {
    for (MAAgent *agent in self.agents) {
        if ([agent.id isEqualToString:agentId]) {
            return agent;
        }
    }
    return nil;
}

/**
 *  发送队列请求
 *
 */
- (NSString *)createQueuedRequestJson:(int)queue {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(MASEND_CHAT_REQUEST);//人工聊天请求
    dic[@"token"] = client.tokenStr;//登录成功后获取到的凭据
    dic[@"time"] = getTimeInterval();//时间戳
    dic[@"queueId"] = @(queue);//排队的队列号
    dic[@"from"] = @"APP";//请求来源
    
    return [dic mj_JSONString];
}
/**
 *  取消排队请求
 *
 *  @param requestId 排队号
 */
- (void)cancelQueuedRequest:(int)requestId {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(MACANCEL_CHAT_REQUEST);//取消聊天请求
    dic[@"token"] = self.tokenStr;//登录成功后获取到的凭据
    dic[@"time"] = getTimeInterval();//时间戳
    dic[@"requestId"] = @(requestId);//排队成功后，获取到的排队号
    
    NSString *msg = [dic mj_JSONString];
//    [client.webSocket send:msg];
}
/**
 *  发送消息
 *
 *  @param msg 消息对象
 */
- (NSString *)createMessageJsonStr:(MAMessage *)msg{
    
    if (self.sessionId == -1) {
        NSLog(@"error: session is nil");
        
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"type"] = @(MASEND_CHAT_MESSAGE);//发送聊天消息
    dic[@"token"] = self.tokenStr;//登录成功后获取到的凭据
    dic[@"time"] = getTimeInterval();//时间戳
    dic[@"sessionId"] = @(self.sessionId);//聊天会话号，排队成功后返回
    dic[@"msg"] = @{@"type":@(msg.type),@"content":msg.content};
    
    return [dic mj_JSONString];
}

NSString *getTimeInterval() {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f", a];//转为字符型
}

BOOL isMAEmpty(id object){
    if ([object isKindOfClass:[NSString class]]) {
        if (!object || [object isEqualToString:@""]) {
            return YES;
        }
    } else {
        if (!object) return YES;
    }
    
    return NO;
}
@end
