//
//  MAChat.h
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+MAJSON.h"
#import "MAClient.h"
#import "MARequest.h"
#import "MASession.h"

@interface MAChat : NSObject

@property (strong, nonatomic, readonly) NSString *tokenStr;
@property (strong, nonatomic, readonly) NSArray *agents;

+ (instancetype)getInstance;

- (void)setClient:(MAClient *)client;
- (void)setRequest:(MARequest *)request;
- (void)setSession:(MASession *)session;
- (void)setTokenStr:(NSString *)tokenStr;
- (void)setAgents:(NSArray *)agents;

- (long)getRequestId;
- (long)getSessionId;
- (MAAgent *)getCurrentAgent;
- (NSDictionary *)getAgentWithId:(NSString *)agentId;

- (void)updateSession:(MAAgent *)agent;
@end
