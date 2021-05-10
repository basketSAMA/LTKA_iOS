//
//  MineViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/9.
//

#import "MineViewController.h"
#import "LTKAContext.h"
#import "RegisterViewController.h"

#import <Masonry/Masonry.h>

@interface MineViewController ()

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *email;
@property (nonatomic, strong) UILabel *conpetence;
@property (nonatomic, strong) UIButton *logOutBtn;

@property (nonatomic, strong) UIButton *logInOrRegisterBtn;

@property (nonatomic, strong) UIView *logInYes;
@property (nonatomic, strong) UIView *logInNo;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Register_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Log_In_Notification object:nil];
    
    [self.view addSubview:self.logInYes];
    [self.logInYes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    [self.view addSubview:self.logInNo];
    [self.logInNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    [self setup];
}

- (void) setup {
    LTKAContext *context = [LTKAContext shareInstance];
    if(context.isLogIn) {
        self.userName.text = [@"用户名：" stringByAppendingString:context.user.userName];
        self.email.text = [@"邮箱：" stringByAppendingString:context.user.email];
        self.conpetence.text = [@"账本权限：" stringByAppendingString:context.user.conpetence == ConpetenceType_nil ? @"没有账本" : context.user.conpetence == ConpetenceType_creator ? @"账本创建者" : @"账本参与者"];
        self.logInYes.hidden = NO;
        self.logInNo.hidden = YES;
    } else {
        self.logInNo.hidden = NO;
        self.logInYes.hidden = YES;
    }
}

- (UIView *)logInYes {
    if(_logInYes == nil) {
        _logInYes = [UIView new];
        
        _userName = [UILabel new];
        [_logInYes addSubview:_userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_logInYes).multipliedBy(0.9);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(_logInYes);
            make.top.equalTo(_logInYes.mas_top);
        }];
        
        _email = [UILabel new];
        [_logInYes addSubview:_email];
        [_email mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_logInYes).multipliedBy(0.9);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(_logInYes);
            make.top.equalTo(_userName.mas_bottom).offset(10);
        }];
        
        _conpetence = [UILabel new];
        [_logInYes addSubview:_conpetence];
        [_conpetence mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_logInYes).multipliedBy(0.9);
            make.height.mas_equalTo(30);
            make.centerX.equalTo(_logInYes);
            make.top.equalTo(_email.mas_bottom).offset(10);
        }];
        
        _logOutBtn = [UIButton new];
        [_logInYes addSubview:_logOutBtn];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setBackgroundColor:[UIColor grayColor]];
        [_logOutBtn addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_logInYes).multipliedBy(0.9);
            make.centerX.equalTo(_logInYes);
            make.top.equalTo(_conpetence.mas_bottom).offset(10);
            make.bottom.equalTo(_logInYes.mas_bottom);
        }];
    }
    return _logInYes;
}

- (UIView *)logInNo {
    if(_logInNo == nil) {
        _logInNo = [UIView new];
        
        _logInOrRegisterBtn = [UIButton new];
        [_logInNo addSubview:_logInOrRegisterBtn];
        [_logInOrRegisterBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_logInOrRegisterBtn setBackgroundColor:[UIColor grayColor]];
        [_logInOrRegisterBtn addTarget:self action:@selector(logInOrRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_logInOrRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_logInNo).multipliedBy(0.9);
            make.centerX.equalTo(_logInNo);
            make.top.equalTo(_logInNo.mas_top);
            make.bottom.equalTo(_logInNo.mas_bottom);
        }];
    }
    return _logInNo;
}

- (void)logOutBtnClick:(UIButton *)btn {
    [[LTKAContext shareInstance] setIsLogIn:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:M_Log_Out_Notification object:nil];
    [self setup];
}

- (void)logInOrRegisterBtnClick:(UIButton *)btn {
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
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
