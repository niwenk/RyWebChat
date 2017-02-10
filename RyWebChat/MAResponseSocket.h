//
//  MAResponseSocket.h
//  SocketDemo
//
//  Created by nwk on 2016/12/22.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAContent : NSObject
@property (assign, nonatomic) int type;
@property (strong, nonatomic) NSString *content;
@end

@interface MAAgent : NSObject
@property (strong, nonatomic) NSString *id;//客服ID
@property (strong, nonatomic) NSString *name;//名字
@property (strong, nonatomic) NSString *icon;//头像url
@property (strong, nonatomic) NSString *comments;//备注信息
@end

@interface MAResponseSocket : NSObject

@property (assign, nonatomic) int type;//请求类型
@property (assign, nonatomic) int requestId;//排队成功后，获取到的排队号
@property (assign, nonatomic) int queueLength;//当前排到第几位
@property (assign, nonatomic) int result;//结果代码
@property (strong, nonatomic) NSString *message;//结果描述
@property (assign, nonatomic) int sessionId;//回话id
@property (strong, nonatomic) NSString *agentId;//客服ID
@property (strong, nonatomic) MAContent *msg;//消息内容
@property (strong, nonatomic) NSArray *agents;//客服资料

@end
