//
//  RegisterViewController.m
//  LO_XMPP01
//
//  Created by 张正 on 15/9/19.
//  Copyright (c) 2015年 张正. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"

@interface RegisterViewController ()<XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[XMPPManager sharedManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"%s__%d__|", __FUNCTION__, __LINE__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"%s__%d__| 注册失败", __FUNCTION__, __LINE__);
}


- (IBAction)registerButtonAction:(UIButton *)sender
{
    [[XMPPManager sharedManager] registerWithUserName:self.userNameTextField.text password:self.passwordTextField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
