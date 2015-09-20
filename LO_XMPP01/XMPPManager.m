//
//  XMPPManager.m
//  LO_XMPP01
//
//  Created by 张正 on 15/9/19.
//  Copyright (c) 2015年 张正. All rights reserved.
//

#import "XMPPManager.h"

// 枚举
typedef NS_ENUM(NSInteger, ConnectToServerPurpose)
{
    ConnectToServerPurposeLogin,
    ConnectToServerPurposeRegister
};

@interface XMPPManager ()

@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) ConnectToServerPurpose connectToServerPurpose;

@end

@implementation XMPPManager

/**
 * 创建单例
 */
+ (XMPPManager *)sharedManager
{
    static XMPPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc] init];
    });
    return manager;
}

/**
 * 初始化方法
 */
- (instancetype)init
{
    if (self = [super init]) {
        // 创建通信通道对象
        self.xmppStream = [[XMPPStream alloc] init];
        // 设置服务器IP地址
        self.xmppStream.hostName = kHostName;
        // 设置服务器端口
        self.xmppStream.hostPort = kHostPort;
        // 添加代理
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return self;
}


/**
 * 登陆方法
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    self.connectToServerPurpose = ConnectToServerPurposeLogin;
    self.password = password;
    // 连接服务器
    [self connectToServerWithUserName:userName];
}

/**
 * 注册方法
 */
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password
{
    self.connectToServerPurpose = ConnectToServerPurposeRegister;
    self.password = password;
    [self connectToServerWithUserName:userName];
}

/**
 * 连接服务器
 */
- (void)connectToServerWithUserName:(NSString *)userName
{
    // 创建XMPPJID对象
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    // 设置通信通道对象的JID
    self.xmppStream.myJID = jid;
    
    // 发送请求
    if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
        // 先发送下线状态
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
        [self.xmppStream sendElement:presence];
        
        // 断开连接
        [self.xmppStream disconnect];
    }
    
    // 向服务器发送请求
    NSError *error = nil;
    
    [self.xmppStream connectWithTimeout:-1 error:&error];
    
    if (error != nil) {
        NSLog(@"%s__%d__%@| 连接失败", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
}

/**
 * 连接超时方法
 */
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s__%d__| 连接服务器超时", __FUNCTION__, __LINE__);
}

/**
 * 连接成功
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    switch (self.connectToServerPurpose) {
        case ConnectToServerPurposeLogin:
            [self.xmppStream authenticateWithPassword:self.password error:nil];
            break;
        case ConnectToServerPurposeRegister:
            [self.xmppStream registerWithPassword:self.password error:nil];
            
        default:
            break;
    }
    
    
    
}






@end
