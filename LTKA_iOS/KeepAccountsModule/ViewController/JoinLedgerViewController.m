//
//  JoinLedgerViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/15.
//

#import "JoinLedgerViewController.h"
#import "LTKAContext.h"
#import "HttpService.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface JoinLedgerViewController ()

@property (nonatomic, strong) UITextField *serialCode;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation JoinLedgerViewController

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
    
    UITextField *serialCode = [UITextField new];
    [view addSubview:serialCode];
    serialCode.clearButtonMode = UITextFieldViewModeAlways;
    serialCode.placeholder = @"账本序列码";
    [serialCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _serialCode = serialCode;
    
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.centerX.equalTo(view);
        make.top.equalTo(serialCode.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    _btn = btn;
}

- (void)btnClick {
    if([@"" isEqualToString:self.serialCode.text]) {
        [WHToast showMessage:@"账本序列码不能为空" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    } else {
        [[HttpService shareInstance] joinLedgerServiceWithSerialCode:self.serialCode.text andUserId:[[LTKAContext shareInstance] user].userId];
    }
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinLedgerFinished:) name:U_Http_Service_Join_Ledger_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)JoinLedgerFinished:(NSNotification *)notification {
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
