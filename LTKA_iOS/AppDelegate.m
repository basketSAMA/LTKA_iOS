//
//  AppDelegate.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/18.
//

#import "AppDelegate.h"
#import "LTKAContext.h"
#import "KeepAccountsModule/KeepAccountsViewController.h"
#import "MineModule/MineViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    LTKAContext *context = [LTKAContext shareInstance];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"email"]) {
        context.isLogIn = YES;
        User *user = [User new];
        user.userId = [userDefault integerForKey:@"userId"];
        user.userName = [userDefault objectForKey:@"userName"];
        user.email = [userDefault objectForKey:@"email"];
        user.password = [userDefault objectForKey:@"password"];
        user.conpetence = [userDefault integerForKey:@"conpetence"];
        user.ledgerId = [userDefault integerForKey:@"ledgerId"];
        context.user = user;
    } else {
        context.isLogIn = NO;
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
