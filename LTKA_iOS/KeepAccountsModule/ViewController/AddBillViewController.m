//
//  AddBillViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/15.
//

#import "AddBillViewController.h"
#import "LTKAContext.h"
#import "HttpService.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface AddBillViewController ()

@end

@implementation AddBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self addObservers];
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddBillFinished:) name:U_Http_Service_Add_Bill_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)AddBillFinished:(NSNotification *)notification {
    NSInteger code = ((NSNumber *)notification.userInfo[@"code"]).integerValue;
    [WHToast showMessage:notification.userInfo[@"msg"] originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    if(code == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
