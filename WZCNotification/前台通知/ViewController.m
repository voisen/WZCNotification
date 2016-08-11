//
//  ViewController.m
//  前台通知
//
//  Created by 邬志成 on 16/8/10.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import "ViewController.h"

#import "WZCNotification.h"

@interface ViewController ()<WZCNotificationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.679 green:0.607 blue:0.567 alpha:1.000];
    
}

-(void)WZCNotificationDidClickWithMsg:(NSString *)msg{

    NSLog(@"点击了->%@",msg);
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [WZCNotification setBackgroundNotiEnable:YES];
    [WZCNotification wzc_notificationWithTitle:@"嘻嘻嘻嘻" msg:@"通知，是运用广泛的知照性公文。用来发布法规、规章，转发上级机关、同级机关和不相隶属机关的公文，批转下级机关的公文，要求下级机关办理某项事务等。通知，一般由标题、主送单位（受文对象）、正文、落款四部分组成。" ];
    
    [WZCNotification setDelegate:self];

}

@end
