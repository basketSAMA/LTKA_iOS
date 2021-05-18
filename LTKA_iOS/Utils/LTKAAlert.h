//
//  LTKAAlert.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SQAlertConfirmHandle)(void);
typedef void(^SQAlertCancleHandle)(void);

@interface LTKAAlert : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(nullable SQAlertConfirmHandle)confirmHandle cancleHandle:(nullable SQAlertCancleHandle)cancleHandle;

@end

NS_ASSUME_NONNULL_END
