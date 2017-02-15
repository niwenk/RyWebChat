//
//  ViewController.m
//  RyWebChat
//
//  Created by nwk on 2017/2/9.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "MARyChatViewController.h"
#import "MJExtension.h"
#import <RongIMKit/RongIMKit.h>
#import "MAClient.h"
#import "MAEliteChat.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)webChatPressed:(id)sender {
    
    
//    [MAClient initializeClient:@"http://118.242.18.190/webchat/rcs"];
//    
//    [[MAClient sharedMAClient] contentRyTokenService:@"test" nickName:@"张三" protrait:@"" complete:^(BOOL result) {
//        if (result) {
//            [self switchChatViewController];
//        } else {
//            
//            NSLog(@"获取token失败");
//        }
//    }];
    
//    MARyChatViewController *chat = [[MARyChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"客服聊天室"];
//    //设置聊天会话界面要显示的标题
//    chat.title = @"客服";
//    
//    //显示聊天会话界面
//    [self.navigationController pushViewController:chat animated:YES];
    
    
    [MAEliteChat initAndStart:MACLIENTSERVERADDR userId:@"test" name:@"张三" portraitUri:@"" queueId:1 complete:^(BOOL result) {
        
        if (result) [self switchChatViewController];
        else NSLog(@"初始化或启动失败");
    }];
    
}

- (void)switchChatViewController {
    //新建一个聊天会话View Controller对象,建议这样初始化
    
    MARyChatViewController *chat = [[MARyChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"EliteCRM"];
    //设置聊天会话界面要显示的标题
    chat.title = @"客服";
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
