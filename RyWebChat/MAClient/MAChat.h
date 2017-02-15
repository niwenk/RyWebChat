//
//  MAChat.h
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAChat : NSObject

@property (strong, nonatomic) NSString *serverAddr;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *portraitUri;
@property (strong, nonatomic) NSString *tokeStr;
@property (assign, nonatomic) int sessionId;
@property (strong, nonatomic) NSArray *agents;

@end
