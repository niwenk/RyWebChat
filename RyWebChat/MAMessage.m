//
//  MAMessage.m
//  SocketDemo
//
//  Created by nwk on 2016/12/16.
//  Copyright © 2016年 nwkcom.sh.n22. All rights reserved.
//

#import "MAMessage.h"
#import "MAClientConfig.h"

@implementation MAMessage

/**
 *  纯文本
 *
 *  @param msg 消息
 *
 *  @return 消息对象
 */
+ (MAMessage *)createTxtObject:(NSString *)msg {
    MAMessage *message = [MAMessage new];
    message.type = MATEXT;
    message.content = msg;
    
    return message;
}

/**
 *  发送图片
 *  @param name 图片名字
 *  @param url 图片服务器地址
 *
 *  @return 消息对象
 */
+ (MAMessage *)createImageObject:(NSString *)name url:(NSString *)url {
    MAMessage *message = [MAMessage new];
    message.type = MAIMG;
    message.content = @{@"name":name,@"url":url};
    
    return message;
}

/**
 *  发送文件
 *  @param name 文件名字
 *  @param url 文件服务器地址
 *
 *  @return 消息对象
 */
+ (MAMessage *)createFileObject:(NSString *)name url:(NSString *)url {
    MAMessage *message = [MAMessage new];
    message.type = MAFILE;
    message.content = @{@"name":name,@"url":url};
    
    return message;
}

/**
 *  发送定位
 *
 *  @return 消息对象
 */
+ (MAMessage *)createLocationObject:(NSString *)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude {
    
    MAMessage *message = [MAMessage new];
    message.type = MALOCATION;
    message.content = @{@"locationAddress":address,@"longitude":longitude,@"latitude":latitude};
    
    return message;
}

/**
 *  发送录音
 *
 *  @return 消息对象
 */
+ (MAMessage *)createRecordObject:(NSString *)url length:(float)lenght{
    
    MAMessage *message = [MAMessage new];
    message.type = MAVOICE;
    message.content = @{@"length":@(lenght),@"url":url};
    
    return message;
}
@end
