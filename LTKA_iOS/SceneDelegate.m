//
//  SceneDelegate.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/18.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "KeepAccountsModule/KeepAccountsViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    if(![scene isKindOfClass:[UIWindowScene class]]) return;
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
    UITabBarController* tab = [UITabBarController new];
    self.window.rootViewController = tab;
    {
        KeepAccountsViewController* vc = [KeepAccountsViewController new];
        vc.tabBarItem.title = @"记账";
        vc.tabBarItem.image = [UIImage imageNamed:@"img1"];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:@"img1"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [tab addChildViewController:nav];
    }
    {
        ViewController* vc = [ViewController new];
        vc.tabBarItem.title = @"资产";
        vc.tabBarItem.image = [UIImage imageNamed:@"img2"];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:@"img2"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [tab addChildViewController:nav];
    }
    {
        ViewController* vc = [ViewController new];
        vc.tabBarItem.title = @"发现";
        vc.tabBarItem.image = [UIImage imageNamed:@"img3"];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:@"img3"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [tab addChildViewController:nav];
    }
    {
        ViewController* vc = [ViewController new];
        vc.tabBarItem.title = @"我的";
        vc.tabBarItem.image = [UIImage imageNamed:@"img4"];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:@"img4"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [tab addChildViewController:nav];
    }
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
