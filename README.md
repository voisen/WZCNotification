# WZCNotification
一行代码就可以搞定前台通知
One line of code to achieve the front notification

## 特性
* 程序在前台时后显示通知
* 支持声音/震动提示
* 支持点击事件
* 全局只有一个类:WZCNotification
* 简单易用,一行代码搞定
* 其他...

## 更新日志
* 2016.8.12 重要修复,其他方向上的提示显示 bug 升级为 V2.0
* 2016.8.11 上传V1.0,添加说明文档

## 缺陷
* 不支持 pod

## 效果图

![通知效果](001.PNG)
![通知效果](002.PNG)

               通知状态                              展开通知状态
## WZCNotification



~~~~objc
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
*  设置通知栏是否显示
*
*  @param enable 默认为显示
*/
+ (void)setBackgroundNotiEnable:(BOOL)enable;

/**
*  设置是否播放系统声音
*
*  @param enable 默认为播放
*/
+ (void)setPlaySystemSound:(BOOL)enable;

@end

~~~~

## 使用

~~~~objc
//你只需要调用这个方法
[WZCNotification wzc_notificationWithTitle:nil msg:
@"通知，是运用广泛的知照性公文。用来发布法规、规章，转发上级机关、同级机关和不相隶属机关的公文，
批转下级机关的公文，要求下级机关办理某项事务等。通知，一般由标题、主送单位（受文对象）、正文、落
款四部分组成。" ];
~~~~

