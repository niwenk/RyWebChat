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
#import "MARequest.h"
#import "MASession.h"

@interface MARyChatViewController ()<RCIMReceiveMessageDelegate>

@end

@implementation MARyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.displayUserNameInCell = NO;
    
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
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
        message.senderUserId = agentId;
        [self updateSession:agentId];
        
    } else if ([message.content isKindOfClass:[EliteMessage class]]) {
        EliteMessage *eliteMsg = (EliteMessage *)message.content;

        NSLog(@"---%@",eliteMsg.message);
        
        [self parseMessage:eliteMsg.message rcMsg:message];
    }
}
/**
 *  更新session
 *
 *  @param agentId 坐席ID
 */
- (void)updateSession:(NSString *)agentId {
    NSDictionary *dic = [[MAChat getInstance] getAgentWithId:agentId];
    MAAgent *agent = [MAAgent initWithUserId:[dic getString:@"id"] name:[dic getString:@"name"] portraitUri:[dic getString:@"icon"]];
    [[MAChat getInstance] updateSession:agent];
}

-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message {
    //定义一个SystemSoundID
    SystemSoundID soundID = 1307;//具体参数详情下面贴出来
    //播放声音
    AudioServicesPlaySystemSound(soundID);
    
    return YES;
}
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
                if (queueLength == 0) {
                    msg = [json getString:@"message"];
                } else {
                    msg = [NSString stringWithFormat:@"还有%d位，等待中...",queueLength];
                }
            } else {
                msg = [json getString:@"message"];
            }
            
            long requestId = [json getLong:@"requestId"];
            
            MARequest *request = [MARequest initWithRequestId:requestId];
            [[MAChat getInstance] setRequest:request];
            
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
        {
            int requestStatus = [json getInt:@"requestStatus"];
            int queueLength = [json getInt:@"queueLength"];
            NSString *content = nil;
            if(requestStatus == MAWAITING){
                content = [NSString stringWithFormat:@"还有%d位，等待中...",queueLength];
                
            } else if (requestStatus == MADROPPED){
                content = @"请求异常丢失";
            } else if (requestStatus == MATIMEOUT){
                content = @"排队超时";
            }
            if (content) [self addTipsMessage:content];
        }
            
            
            break;
        case MACHAT_STARTED://通知客户端可以开始聊天
        {
            //TODO 记录本次聊天的 sessionId
            NSLog(@"通知客户端可以开始聊天");
            long sessionId = [json getLong:@"sessionId"];
            NSArray *agents = [json getObject:@"agents"];
            
            NSDictionary *dic = agents.firstObject;
            
            MAAgent *agent = [MAAgent initWithUserId:[dic getString:@"id"] name:[dic getString:@"name"] portraitUri:[dic getString:@"icon"]];
            
            MASession *session = [MASession initWithSessionId:sessionId agent:agent];
            
            [[MAChat getInstance] setSession:session];
            [[MAChat getInstance] setAgents:[json getObject:@"agents"]];
            
            NSString *tipsMsg = [NSString stringWithFormat:@"坐席[%@]为您服务",agent.name];
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
            [self addTipsMessage:@"会话结束"];
            
            [self isEnableInputBarControl:NO];
            
            break;
        case MAAGENT_SEND_MESSAGE://坐席发送消息
            NSLog(@"坐席发送消息");
        {
            NSDictionary *msgDic = [json getObject:@"msg"];
            int msgType = [msgDic getInt:@"type"];
            if(msgType == MASYSTEM_NOTICE) {
                int noticeType = [msgDic getInt:@"noticeType"];
                if(noticeType == MANORMAL) {
                    NSString *content = [msgDic getString:@"content"];
                    EliteMessage *eliteMsg = (EliteMessage *)rcMsg.content;
                    eliteMsg.message = content;
                    
                    [self appendAndDisplayMessage:rcMsg];
                }
            }
        }
            break;
            
        default:
            break;
    }
}
/**
 *  是否启动会话页面下方的输入工具栏
 *
 *  @param enable 启用
 */
- (void)isEnableInputBarControl:(BOOL)enable {
    self.chatSessionInputBarControl.userInteractionEnabled = enable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
