//
//  MARyChatViewController.m
//  RyWebChat
//
//  Created by nwk on 2017/2/9.
//  Copyright © 2017年 nwkcom.sh.n22. All rights reserved.
//

#import "MARyChatViewController.h"
#import "EliteMessage.h"
#import "MAChat.h"
#import "MAJSONObject.h"

@interface MARyChatViewController ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>

@end

@implementation MARyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.displayUserNameInCell = NO;
    
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    [RCIM sharedRCIM].userInfoDataSource = self;
    
}

//小灰色提示条
- (void)addTipsMessage:(NSString *)msg {
    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage
     notificationWithMessage:msg extra:nil];
    
    // 如果不保存到本地数据库，需要初始化消息实体并将messageId要设置为－1。
    RCMessage *insertMessage =[[RCMessage alloc] initWithType:self.conversationType
                                          targetId:self.targetId
                                         direction:MessageDirection_SEND
                                         messageId:-1
                                           content:warningMsg];
    
    // 在当前聊天界面插入该消息
    [self appendAndDisplayMessage:insertMessage];
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    if ([messageContent isKindOfClass:[RCTextMessage class]] || [messageContent isKindOfClass:[RCLocationMessage class]] ||
        [messageContent isKindOfClass:[RCImageMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)messageContent;
        textMsg.extra = [MAMessageUtils getTextMessageJsonStr];
        
    } else if ([messageContent isKindOfClass:[RCVoiceMessage class]]) {
        RCVoiceMessage *voiceMsg = (RCVoiceMessage *)messageContent;
        voiceMsg.extra = [MAMessageUtils getVoiceMessageJsonStr:voiceMsg.duration];
    }
    
    return messageContent;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    if ([message.content isKindOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *infoMsg = (RCInformationNotificationMessage *)message.content;
        
        NSLog(@"---%@",infoMsg.message);
        
        [self parseMessage:infoMsg.message rcMsg:message];

    } else if ([message.content isKindOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *textMsg = (RCTextMessage *)message.content;
        MAJSONObject *json = [MAJSONObject initJSONObject:textMsg.extra];
        NSString *agentId = [json getString:@"agentId"];
        [[MAChat getInstance] setCurrentAgentId:agentId];
        
    } else if ([message.content isKindOfClass:[EliteMessage class]]) {
        EliteMessage *eliteMsg = (EliteMessage *)message.content;

        NSLog(@"---%@",eliteMsg.message);
        
        [self parseMessage:eliteMsg.message rcMsg:message];
    }
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    NSLog(@"----%@",userId);
    
    NSDictionary *agent = [MAChat getCurrentAgent];
    
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:[agent getString:@"id"] name:[agent getString:@"name"] portrait:[agent getString:@"icon"]];
    
    completion(user);
}

-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message {
    //定义一个SystemSoundID
    SystemSoundID soundID = 1307;//具体参数详情下面贴出来
    //播放声音
    AudioServicesPlaySystemSound(soundID);
    
    return YES;
}

//-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
//                      withSenderName:(NSString *)senderName {
//    
//    //定义一个SystemSoundID
//    SystemSoundID soundID = 1307;//具体参数详情下面贴出来
//    //播放声音
//    AudioServicesPlaySystemSound(soundID);
//    
//    return YES;
//}
/**
 *  解析消息
 *
 *  @param message 消息
 */
- (void)parseMessage:(NSString *)message rcMsg:(RCMessage *)rcMsg {
    
    MAJSONObject *json = [MAJSONObject initJSONObject:message];
    
    switch ([json getInt:@"type"]) {
            //客户发送
        case MASEND_CHAT_REQUEST: //发出聊天请求 tips 提示
        {
            NSLog(@"发出聊天请求");
            NSString *msg = [json getString:@"message"];
            if ([json getInt:@"result"] == MASUCCESS) {
                int queueLength = [json getInt:@"queueLength"];
                if (queueLength == 0) break;
                msg = [NSString stringWithFormat:@"还有%d位，等待中...",queueLength];
            }
            [self addTipsMessage:msg];
        }
            break;
        case MACANCEL_CHAT_REQUEST: //取消聊天请求
            NSLog(@"取消聊天请求");
            
            break;
        case MACLOSE_SESSION: //结束聊天
            NSLog(@"结束聊天");
            
            break;
        case MARATE_SESSION: //满意度评价
            NSLog(@"满意度评价");
            
            break;
        case MASEND_CHAT_MESSAGE: //客户端发送的消息
            NSLog(@"客户端发送的消息");
            
            break;
        case MASEND_PRE_CHAT_MESSAGE: //发送预消息（还没排完队时候的消息）
            NSLog(@"发送预消息（还没排完队时候的消息）");
            
            break;
            
            //客户接受
        case MACHAT_REQUEST_STATUS_UPDATE://聊天排队状态更新
            NSLog(@"聊天排队状态更新");
            [self makeChatRequest:json rcMsg:rcMsg];
            break;
        case MACHAT_STARTED://通知客户端可以开始聊天
        {
            //TODO 记录本次聊天的 sessionId
            NSLog(@"通知客户端可以开始聊天");
            [[MAChat getInstance] setSessionId:[json getInt:@"sessionId"]];
            [[MAChat getInstance] setAgents:[json getObject:@"agents"]];
            
            NSDictionary *agent = [MAChat getInstance].agents.firstObject;
            NSString *tipsMsg = [NSString stringWithFormat:@"坐席[%@]为您服务",[agent getString:@"name"]];
            [self addTipsMessage:tipsMsg];
        }
            break;
        case MAAGENT_PUSH_RATING://坐席推送了满意度
            NSLog(@"坐席推送了满意度");
            
            break;
        case MAAGENT_UPDATED://坐席人员变更
            NSLog(@"坐席人员变更");
            
            break;
        case MAAGENT_CLOSE_SESSION://坐席关闭
            NSLog(@"坐席关闭");
            
            break;
        case MAAGENT_SEND_MESSAGE://坐席发送消息
            NSLog(@"坐席发送消息");
            //TODO 不会进入该方法
            break;
            
        default:
            break;
    }
}

- (void)makeChatRequest:(MAJSONObject *)response rcMsg:(RCMessage *)rcMsg {
    NSString *message = [response getString:@"message"];
    switch ([response getInt:@"result"]) {
        case MAWAITING:////等待中
            message = [NSString stringWithFormat:@"还有%d位，等待中...",[response getInt:@"queueLength"]];
            break;
        case MAACCEPTED://坐席拒绝
            
            break;
        case MAREFUSED://坐席拒绝
            
            break;
        case MATIMEOUT://排队超时
            message = @"排队超时";
            break;
        case MADROPPED://异常丢失
            message = @"请求异常丢失";
            break;
        case MANO_AGENT_ONLINE://在工作时间
            
            break;
        case MAOFF_HOUR://不在工作时间
            
            break;
        case MACANCELED_BY_CLIENT://被客户取消
            
            break;
        case MAENTERPRISE_WECHAT_ACCEPTED://坐席企业号接收
            
            break;
            
        default:
            break;
    }
    if (message) {
        [self addTipsMessage:message];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
