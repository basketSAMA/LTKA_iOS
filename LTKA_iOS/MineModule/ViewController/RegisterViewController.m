//
//  RegisterViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/9.
//

#import "RegisterViewController.h"
#import "HttpService.h"
#import "LTKAContext.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation RegisterViewController

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
    
    UITextField *email = [UITextField new];
    [view addSubview:email];
    email.clearButtonMode = UITextFieldViewModeAlways;
    email.placeholder = @"邮箱";
    [email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _email = email;
    
    UITextField *password = [UITextField new];
    [view addSubview:password];
    password.secureTextEntry = YES;
    password.clearButtonMode = UITextFieldViewModeAlways;
    password.placeholder = @"密码";
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(email.mas_bottom).offset(10);
    }];
    _password = password;
    
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.centerX.equalTo(view);
        make.top.equalTo(password.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    _btn = btn;
}

- (void)btnClick {
    if([@"" isEqualToString:self.email.text]) {
        [WHToast showMessage:@"邮箱不能为空" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    } else if([@"" isEqualToString:self.password.text]) {
        [WHToast showMessage:@"密码不能为空" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    } else {
        [[HttpService shareInstance] registerServiceWithEmail:self.email.text andPassword:self.password.text];
    }
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFinished:) name:U_Http_Service_Register_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logInFinished:) name:U_Http_Service_Log_In_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)registerFinished:(NSNotification *)notification {
    NSInteger code = ((NSNumber *)notification.userInfo[@"code"]).integerValue;
    [WHToast showMessage:notification.userInfo[@"msg"] originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    if(code == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(code == 1) {
        [[HttpService shareInstance] logInServiceWithEmail:self.email.text andPassword:self.password.text];
    }
}

- (void)logInFinished:(NSNotification *)notification {
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
