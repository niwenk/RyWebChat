//
//  MAChat.h
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAClient.h"

@interface MAChat : NSObject

@property (strong, nonatomic, readonly) NSString *tokenStr;
@property (assign, nonatomic, readonly) int sessionId;
@property (strong, nonatomic, readonly) NSArray *agents;
@property (strong, nonatomic, readonly) NSString *currentAgentId;

+ (instancetype)getInstance;

- (void)setClient:(MAClient *)client;
- (void)setTokenStr:(NSString *)tokenStr;
- (void)setSessionId:(int)sessionId;
- (void)setAgents:(NSArray *)agents;
- (void)setCurrentAgentId:(NSString *)currentAgentId;
+ (NSDictionary *)getCurrentAgent;
@end
