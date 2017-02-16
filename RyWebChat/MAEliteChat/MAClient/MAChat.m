//
//  MAChat.m
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MAChat.h"

@interface MAChat()
@property (strong, nonatomic) MAClient *client;
@property (strong, nonatomic) MARequest *request;
@property (strong, nonatomic) MASession *session;
@property (strong, nonatomic, readwrite) NSString *tokenStr;
@property (strong, nonatomic, readwrite) NSArray *agents;

@end

@implementation MAChat

static MAChat *chat;

+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chat = [[MAChat alloc] init];
    });
    
    return chat;
}

- (void)setClient:(MAClient *)client {
    _client = client;
}
- (void)setRequest:(MARequest *)request {
    _request = request;
}
- (void)setTokenStr:(NSString *)tokenStr {
    _tokenStr = tokenStr;
}
- (void)setSession:(MASession *)session {
    _session = session;
}
- (void)setAgents:(NSArray *)agents {
    _agents = agents;
}

- (NSDictionary *)getAgentWithId:(NSString *)agentId {
    
    for (NSDictionary *agent in self.agents) {
        if ([[agent getString:@"id"] isEqualToString:agentId]) {
            return agent;
        }
    }
    return nil;
}

- (long)getRequestId {
    if (self.request) {
        return self.request.requestId;
    }
    
    return 0;
}

- (long)getSessionId {
    if (self.session) {
        return self.session.sessionId;
    }
    
    return 0;
}

- (MAAgent *)getCurrentAgent {
    if (self.session) {
        return self.session.agent;
    }
    
    return nil;
}

- (MAClient *)getClient {
    
    return self.client;
}

- (void)updateSession:(MAAgent *)agent {
    self.session.agent = agent;
}
@end
