//
//  MAMessageUtils.m
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAMessageUtils.h"

@implementation MAMessageUtils

+ (void)sendChatRequest:(NSString *)tokenStr queueId:(int)queueId from:(NSString *)from {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(MASEND_CHAT_REQUEST);//人工聊天请求
    dic[@"token"] = tokenStr;//登录成功后获取到的凭据
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



@end
