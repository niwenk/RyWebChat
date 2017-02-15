//
//  MAMessageUtils.h
//  RyWebChat
//
//  Created by nwk on 2017/2/15.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMessageUtils : NSObject

+ (void)sendChatRequest:(NSString *)tokenStr queueId:(int)queueId from:(NSString *)from;

@end
