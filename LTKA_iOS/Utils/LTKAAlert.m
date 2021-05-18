//
//  LTKAAlert.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/18.
//

#import "LTKAAlert.h"

#import <UIKit/UIKit.h>

@implementation LTKAAlert

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(nullable SQAlertConfirmHandle)confirmHandle cancleHandle:(nullable SQAlertCancleHandle)cancleHandle {
   UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancleHandle) {
            cancleHandle();
        }
    }];
    UIAlertAction *confirAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandle) {
            confirmHandle();
        }
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirAction];
    [[LTKAAlert currentViewController] presentViewController:alertVC animated:YES completion:nil];
}

+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *presentedVC = [[window rootViewController] presentedViewController];
    if (presentedVC) {
        return presentedVC;
    } else {
        return window.rootViewController;
    }
}

@end
