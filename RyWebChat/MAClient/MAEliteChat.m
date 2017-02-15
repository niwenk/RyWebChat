//
//  MAEliteChat.m
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAEliteChat.h"
#import "MAMessageUtils.h"

@interface MAEliteChat()

@property (strong, nonatomic) NSString *serverAddr;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *portraitUri;
@property (strong, nonatomic) NSString *tokeStr;
@property (assign, nonatomic) int queueId;//排队号;
@property (assign, nonatomic) BOOL initialized;
@property (assign, nonatomic) BOOL startChatReady;
@property (assign, nonatomic) int sessionId;

@end

@implementation MAEliteChat

static MAEliteChat *eliteChat=nil;

+ (instancetype)shareEliteChat {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eliteChat = [[MAEliteChat alloc] init];
    });
    
    return eliteChat;
}

+ (instancetype)initAndStart:(NSString *)serverAddr userId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)portraitUri queueId:(int)queueId complete:(void (^)(BOOL result))complete {
    
    [MAEliteChat shareEliteChat];
    eliteChat.serverAddr = serverAddr;
    eliteChat.userId = userId;
    eliteChat.name = name;
    eliteChat.portraitUri = portraitUri;
    eliteChat.queueId = queueId;
    eliteChat.startChatReady = YES;
    
    [eliteChat contentRyTokenService:serverAddr userId:userId nickName:name protrait:portraitUri complete:^(NSString *token) {
        
        if (isEliteEmpty(token)) {
            complete(NO);
        } else {
            eliteChat.tokeStr = token;
            
            eliteChat.initialized = YES;
            
            [self startChat:queueId complete:^{
                complete(YES);
            }];
        }
    }];
    
    return eliteChat;
}

+ (instancetype)initElite:(NSString *)serverAddr userId:(NSString *)userId name:(NSString *)name portraitUri:(NSString *)portraitUri complete:(void (^)(BOOL result))complete {
    
    [MAEliteChat shareEliteChat];
    
    eliteChat.serverAddr = serverAddr;
    eliteChat.userId = userId;
    eliteChat.name = name;
    eliteChat.portraitUri = portraitUri;
    
    [eliteChat contentRyTokenService:serverAddr userId:userId nickName:name protrait:portraitUri complete:^(NSString *token) {
        
        if (isEliteEmpty(token)) {
            complete(NO);
        } else {
            eliteChat.tokeStr = token;
            
            eliteChat.initialized = YES;
            complete(YES);
        }
    }];
    
    return eliteChat;
}

+ (void)startChat:(int)queueId complete:(void (^)())complete {
    if (!eliteChat) {
        NSLog(@"未初始化");
        return;
    }
    
    eliteChat.queueId = queueId;
    
    if (eliteChat.initialized) {
        //发出聊天排队请求
        [MAMessageUtils sendChatRequest:eliteChat.tokeStr queueId:queueId from:@"APP"];
        //启动聊天会话界面
        complete();
    }
}

- (void)contentRyTokenService:(NSString *)serverAddr userId:(NSString *)userId nickName:(NSString *)nickName protrait:(NSString *)portraitUri complete:(void (^)(NSString *token))complete  {
    
    if (isEliteEmpty(serverAddr)) return complete(nil);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"action"] = @"login";
    dic[@"userId"] = userId;
    dic[@"name"] = nickName;
    dic[@"portraitUri"] = portraitUri;
    
    [MAHttpService getRyToken:serverAddr paramer:dic success:^(NSString *token) {
        
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"---%@",userId);
            
            [self loginSuccess:@"张三" userId:userId portrait:@"" token:token];
            
            complete(token);
            
        } error:^(RCConnectErrorCode status) {
            //TODO 获取token失败
            
            NSLog(@"---%zd",status);
            complete(nil);
            
        } tokenIncorrect:^{
            [self contentRyTokenService:serverAddr userId:userId nickName:nickName protrait:portraitUri complete:complete];
        }];
        
    } error:^(NSError *error) {
        NSLog(@"error:%@",error);
        complete(nil);
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

/**
 *  发送文本消息
 *
 *  @param msg 消息对象
 */
- (NSString *)createTextMessageJsonStr {
    
    if (self.sessionId == -1) {
        NSLog(@"error: session is nil");
        
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = self.tokeStr;//登录成功后获取到的凭据
    dic[@"sessionId"] = @(self.sessionId);//聊天会话号，排队成功后返回
    
    return [dic mj_JSONString];
}

BOOL isEliteEmpty(id object){
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
