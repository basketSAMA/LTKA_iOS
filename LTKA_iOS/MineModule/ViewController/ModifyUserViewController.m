//
//  ModifyUserViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/16.
//

#import "ModifyUserViewController.h"

#import "LTKAContext.h"
#import "HttpService.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface ModifyUserViewController ()

@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ModifyUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self addObservers];
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    UITextField *userName = [UITextField new];
    [view addSubview:userName];
    userName.clearButtonMode = UITextFieldViewModeAlways;
    userName.placeholder = @"用户名";
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _userName = userName;
    
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.centerX.equalTo(view);
        make.top.equalTo(userName.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    _btn = btn;
}

- (void)btnClick {
    if([@"" isEqualToString:self.userName.text]) {
        [WHToast showMessage:@"用户名不能为空" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    } else {
        [LTKAContext shareInstance].user.userName = self.userName.text;
        [[HttpService shareInstance] ModifyUserService];
    }
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyFinished:) name:U_Http_Service_Modify_User_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)modifyFinished:(NSNotification *)notification {
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
