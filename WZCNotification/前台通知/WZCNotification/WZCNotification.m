//
//  WZCNotification.m
//  前台通知
//
//  Created by 邬志成 on 16/8/10.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import "WZCNotification.h"
@import AVFoundation;

#define Noti_Height 80
#define Font_Size 13

@import UIKit;

@interface WZCNotification()

@property (nonatomic,weak) id<WZCNotificationDelegate> delegate;

@end

@implementation WZCNotification
static WZCNotification *noti;
+ (WZCNotification *)shareNitifacation{
    
    if (noti == nil) {
        noti = [[WZCNotification alloc]init];
    }
    return noti;
    
}

+ (void)setDelegate:(id<WZCNotificationDelegate>)delegate{
    
    [[self class] shareNitifacation].delegate = delegate;
    
}

UIWindow *noti_window;
NSTimer *timer;
static BOOL backgroundNotiEnalble = NO;
static BOOL playSystemSound = YES;
static NSDictionary *infoPlist;

+ (void)wzc_notificationWithTitle:(NSString *)title msg:(NSString *)msg{

   if (![[[UIApplication sharedApplication] currentUserNotificationSettings] types])
       return;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    
    
    if (noti_window) noti_window.hidden = YES;
    noti_window = [[UIWindow alloc]initWithFrame:CGRectMake(0, - Noti_Height,  [UIScreen mainScreen].bounds.size.width, Noti_Height)];
    noti_window.hidden = NO;
    noti_window.backgroundColor = [UIColor colorWithRed:0.180 green:0.125 blue:0.051 alpha:1.00];
    noti_window.windowLevel = UIWindowLevelAlert;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, Noti_Height * 0.34, Noti_Height * 0.34)];
    NSString *iconName = [infoPlist[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"] lastObject];
    imgView.image = [UIImage imageNamed:iconName];
    if (imgView.image == nil) {
        imgView.backgroundColor = [UIColor whiteColor];
    }
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
    [noti_window addSubview:imgView];
    NSString *msg_title;
    if (title == nil || [title isEqualToString:@""]) {
        msg_title = infoPlist[@"CFBundleDisplayName"];
    }else{
        msg_title = title;
    }
    if (msg_title == nil || [msg_title isEqualToString:@""]) {
        msg_title = @"新的消息";
    }
    UIFont *title_font = [UIFont systemFontOfSize:Font_Size weight:bold];
    CGSize title_size = [msg_title sizeWithAttributes:@{NSFontAttributeName:title_font}];
    
    CGFloat title_maxWidth = noti_window.frame.size.width - (CGRectGetMaxX(imgView.frame) + 5) - 40;
    
    if (title_size.width > title_maxWidth) {
        title_size.width = title_maxWidth;
    }
    
    UILabel *noti_title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, imgView.center.y - title_size.height / 2.0f, title_size.width, title_size.height)];
    noti_title.font = title_font;
    noti_title.text = msg_title;
    noti_title.textColor = [UIColor whiteColor];
    [noti_window addSubview:noti_title];
    
    UILabel *title_now = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noti_title.frame) + 6, noti_title.frame.origin.y,40, noti_title.frame.size.height)];
    title_now.textColor = [UIColor whiteColor];
    title_now.text = @"现在";
    title_now.font = [UIFont systemFontOfSize:Font_Size - 1];
    [noti_window addSubview:title_now];
    
    UILabel *noti_msg = [[UILabel alloc]initWithFrame:CGRectMake(noti_title.frame.origin.x, CGRectGetMaxY(noti_title.frame), noti_window.frame.size.width - noti_title.frame.origin.x - 15, noti_window.frame.size.height - CGRectGetMaxY(imgView.frame) - 7)];
    noti_msg.font = [UIFont systemFontOfSize:Font_Size];
    noti_msg.text = msg;
    noti_msg.textColor = [UIColor whiteColor];
    noti_msg.numberOfLines = 2;
    noti_msg.tag = 10;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:[self class] action:@selector(tap:)];
    [noti_window addGestureRecognizer:tap];
    [noti_window addSubview:noti_msg];
    
    
    UIButton *noti_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    noti_Btn.frame = CGRectMake(0, 0, 40, 7);
    noti_Btn.center = CGPointMake(noti_window.center.x, Noti_Height - 9);
    noti_Btn.backgroundColor = [UIColor colorWithRed:0.489 green:0.350 blue:0.251 alpha:1.000];
    noti_Btn.layer.cornerRadius = 3.5f;
    noti_Btn.layer.masksToBounds = YES;
    noti_Btn.tag = 11;
    noti_Btn.enabled = NO;
    [noti_window addSubview:noti_Btn];
    
    UISwipeGestureRecognizer *swipe_down = [[UISwipeGestureRecognizer alloc]initWithTarget:[self class] action:@selector(swipe_down:)];
    swipe_down.numberOfTouchesRequired = 1;
    swipe_down.direction = UISwipeGestureRecognizerDirectionDown;
    [noti_window addGestureRecognizer:swipe_down];
    
    UISwipeGestureRecognizer *swipe_up = [[UISwipeGestureRecognizer alloc]initWithTarget:[self class] action:@selector(swipe_up:)];
    swipe_up.numberOfTouchesRequired = 1;
    swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
    [noti_window addGestureRecognizer:swipe_up];
    
    CGRect frame = noti_window.frame;
    frame.origin.y = 0;
    
    if (playSystemSound) [[self class] playSystemSound];
    if (backgroundNotiEnalble) [[self class] notification_systemWithTitle:title msg:msg];
    
    [UIView animateWithDuration:0.3 animations:^{
        noti_window.frame = frame;
    } completion:^(BOOL finished) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer timerWithTimeInterval:3 target:[self class] selector:@selector(dismiss) userInfo:nil repeats:NO];
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    }];
}

+ (void)dismiss{
    
    CGRect frame = CGRectMake(0, -noti_window.frame.size.height, noti_window.frame.size.width, noti_window.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        noti_window.frame = frame;
    } completion:^(BOOL finished) {
        noti_window.hidden = YES;
        noti_window = nil;
        [timer invalidate];
        timer = nil;
    }];
}

+ (void)swipe_down:(UISwipeGestureRecognizer *)swipe{
    [timer invalidate];
    timer = nil;
    UILabel *label = [noti_window viewWithTag:10];
    label.numberOfLines = 0;
    CGFloat height = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;

    CGRect window_frame = noti_window.frame;
    window_frame.size.height = window_frame.size.height + height - label.frame.size.height + 5;
    if (window_frame.size.height <= Noti_Height) {
        return;
    }
    CGRect label_frame = label.frame;
    label_frame.size.height = height;
    UIButton *btn = [noti_window viewWithTag:11];
    CGRect btn_frame = btn.frame;
    btn_frame.origin.y = window_frame.size.height - btn.frame.size.height - 5;
    
    [UIView animateWithDuration:0.1 animations:^{
        noti_window.frame = window_frame;
        label.frame = label_frame;
        btn.frame = btn_frame;
    }];
    
}

+ (void)swipe_up:(UISwipeGestureRecognizer *)swipe{
    [WZCNotification dismiss];
}

+ (void)tap:(UIGestureRecognizer*)tap{
    
    if([[[self class] shareNitifacation].delegate respondsToSelector:@selector(WZCNotificationDidClickWithMsg:)]){
        UILabel *label = [noti_window viewWithTag:10];
        [[[self class] shareNitifacation].delegate WZCNotificationDidClickWithMsg:label.text];
    }
    [[self class] dismiss];
}

+ (void)notification_systemWithTitle:(NSString *)title msg:(NSString *)msg{

    UILocalNotification *noti = [[UILocalNotification alloc]init];
    noti.alertTitle = title;
    noti.alertBody = msg;
    noti.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    
}

+ (void)playSystemSound{
    
    AudioServicesPlayAlertSound(1012);
    
}

+ (void)setBackgroundNotiEnable:(BOOL)enable{

    backgroundNotiEnalble = enable;

}

+ (void)setPlaySystemSound:(BOOL)enable{

    playSystemSound = enable;

}
@end
