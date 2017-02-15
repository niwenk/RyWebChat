//
//  MAChat.m
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAChat.h"
#import "NSDictionary+MAJSON.h"

@interface MAChat()
@property (strong, nonatomic) MAClient *client;
@property (assign, nonatomic, readwrite) int sessionId;
@property (strong, nonatomic, readwrite) NSString *tokenStr;
@property (strong, nonatomic, readwrite) NSArray *agents;
@property (strong, nonatomic, readwrite) NSString *currentAgentId;

@end

@implementation MAChat

static MAChat *chat;

+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chat = [[MAChat alloc] init];
        chat.sessionId = -1;
    });
    
    return chat;
}

- (void)setClient:(MAClient *)client {
    _client = client;
}
- (void)setTokenStr:(NSString *)tokenStr {
    _tokenStr = tokenStr;
}
- (void)setSessionId:(int)sessionId {
    _sessionId = sessionId;
}
- (void)setAgents:(NSArray *)agents {
    _agents = agents;
}
-(void)setCurrentAgentId:(NSString *)currentAgentId {
    _currentAgentId = currentAgentId;
}

+ (NSDictionary *)getCurrentAgent {
    
    MAChat *chat = [MAChat getInstance];
    
    for (NSDictionary *agent in chat.agents) {
        if ([[agent getString:@"id"] isEqualToString:chat.currentAgentId]) {
            return agent;
        }
    }
    return nil;
}
@end
