//
//  MAMessageUtils.m
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAMessageUtils.h"
#import "MAChat.h"

@implementation MAMessageUtils
/**
 *  发送排队请求
 *
 *  @param queueId 队列号
 *  @param from    请求来源
 */
+ (void)sendChatRequest:(int)queueId from:(NSString *)from {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(MASEND_CHAT_REQUEST);//人工聊天请求
    dic[@"token"] = [MAChat getInstance].tokenStr;//登录成功后获取到的凭据
    dic[@"queueId"] = @(queueId);//排队的队列号
    dic[@"from"] = from;//请求来源
    
    NSString *jsonStr = [dic mj_JSONString];
    
    RCInformationNotificationMessage *warningMsg =
    [RCInformationNotificationMessage
     notificationWithMessage:jsonStr extra:nil];
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_SYSTEM targetId:CHAT_TARGET_ID content:warningMsg pushContent:nil pushData:nil success:^(long messageId) {
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
}
/**
 *  发送文本消息
 *
 *  @param msg 消息对象
 */
+ (NSString *)getTextMessageJsonStr {
    
    if ([MAChat getInstance].sessionId == -1) {
        NSLog(@"error: session is nil");
        
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [MAChat getInstance].tokenStr;//登录成功后获取到的凭据
    dic[@"sessionId"] = @([MAChat getInstance].sessionId);//聊天会话号，排队成功后返回
    
    return [dic mj_JSONString];
}
/**
 *  发送语音消息
 *
 *  @param msg 消息对象
 */
+ (NSString *)getVoiceMessageJsonStr:(long long)duration {

    if ([MAChat getInstance].sessionId == -1) {
        NSLog(@"error: session is nil");

        return nil;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"token"] = [MAChat getInstance].tokenStr;//登录成功后获取到的凭据
    dic[@"length"] = @(duration);//时长
    dic[@"sessionId"] = @([MAChat getInstance].sessionId);//聊天会话号，排队成功后返回

    return [dic mj_JSONString];
}

@end
