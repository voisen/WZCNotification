//
//  WZCNotification.h
//  前台通知
//
//  Created by 邬志成 on 16/8/10.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WZCNotificationDelegate <NSObject>

- (void)WZCNotificationDidClickWithMsg:(NSString *)msg;

@end



@interface WZCNotification : NSObject
/**
 *  通知
 *
 *  @param title    通知的标题
 *  @param msg      通知的内容
 */
+ (void)wzc_notificationWithTitle:(NSString *)title msg:(NSString *)msg;
/**
 *  dismiss 通知
 */
+ (void)dismiss;
/**
 *  设置代理
 *
 *  @param delegate 代理对象
 */
+ (void)setDelegate:(id<WZCNotificationDelegate>)delegate;

/**
 *  设置通知栏是否显示(容易递归,建议使用默认)
 *
 *  @param enable 默认为不显示
 */
+ (void)setBackgroundNotiEnable:(BOOL)enable;

/**
 *  设置是否播放系统声音
 *
 *  @param enable 默认为播放
 */
+ (void)setPlaySystemSound:(BOOL)enable;

@end
