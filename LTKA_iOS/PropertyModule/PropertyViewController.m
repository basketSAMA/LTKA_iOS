//
//  PropertyViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/17.
//

#import "PropertyViewController.h"
#import "KeepAccountsViewController.h"

#import "LTKAContext.h"
#import "Bill.h"
#import "DataArrayGetter.h"

#import <Masonry/Masonry.h>

@interface PropertyViewController ()

@property (nonatomic, strong) UILabel *tips;

@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UILabel *cash;
@property (nonatomic, strong) UILabel *alipay;
@property (nonatomic, strong) UILabel *wechat;
@property (nonatomic, strong) UILabel *onlinebanking;
@property (nonatomic, strong) UILabel *summary;

@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"资产";
    // Do any additional setup after loading the view.
    
    [self addObservers];
    
    // 背景图片（导航栏有毛玻璃效果）
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flower"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imgView];
    
    UILabel *tips = [UILabel new];
    [self.view addSubview:tips];
    tips.text = @"请先登录且拥有账本后查看";
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    _tips = tips;
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    _displayView = view;
    
    UILabel *cash = [UILabel new];
    [view addSubview:cash];
    [cash mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _cash = cash;
    
    UILabel *alipay = [UILabel new];
    [view addSubview:alipay];
    [alipay mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(cash.mas_bottom).offset(10);
    }];
    _alipay = alipay;
    
    UILabel *wechat = [UILabel new];
    [view addSubview:wechat];
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(alipay.mas_bottom).offset(10);
    }];
    _wechat = wechat;
    
    UILabel *onlinebanking = [UILabel new];
    [view addSubview:onlinebanking];
    [onlinebanking mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(wechat.mas_bottom).offset(10);
    }];
    _onlinebanking = onlinebanking;
    
    UILabel *summary = [UILabel new];
    [view addSubview:summary];
    [summary mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(onlinebanking.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    _summary = summary;
    
    [self setup];
}

- (void)setup {
    if([LTKAContext shareInstance].isLogIn && [LTKAContext shareInstance].user.conpetence != ConpetenceType_nil) {
        NSArray<Bill *> *bills = [KeepAccountsViewController shareInstance].dataArray;
        DataArrayGetter *dag = [DataArrayGetter shareInstance];
        
        NSPredicate* predicateForCash = [NSPredicate predicateWithFormat:@"(billFlowType == 0)"];
        NSArray<Bill *> *billsForCash = [bills filteredArrayUsingPredicate:predicateForCash];
        NSNumber *cashSum = [billsForCash valueForKeyPath:@"@sum.money.floatValue"];
        self.cash.text = [NSString stringWithFormat:@"%@: ¥%@", dag.billFlowTypeArray[0], cashSum.description];
        
        NSPredicate* predicateForAlipay = [NSPredicate predicateWithFormat:@"(billFlowType == 1)"];
        NSArray<Bill *> *billsForAlipay = [bills filteredArrayUsingPredicate:predicateForAlipay];
        NSNumber *alipaySum = [billsForAlipay valueForKeyPath:@"@sum.money.floatValue"];
        self.alipay.text = [NSString stringWithFormat:@"%@: ¥%@", dag.billFlowTypeArray[1], alipaySum.description];
        
        NSPredicate* predicateForWechat = [NSPredicate predicateWithFormat:@"(billFlowType == 2)"];
        NSArray<Bill *> *billsForWechat = [bills filteredArrayUsingPredicate:predicateForWechat];
        NSNumber *wechatSum = [billsForWechat valueForKeyPath:@"@sum.money.floatValue"];
        self.wechat.text = [NSString stringWithFormat:@"%@: ¥%@", dag.billFlowTypeArray[2], wechatSum.description];
        
        NSPredicate* predicateForOnlinebanking = [NSPredicate predicateWithFormat:@"(billFlowType == 3)"];
        NSArray<Bill *> *billsForOnlinebanking = [bills filteredArrayUsingPredicate:predicateForOnlinebanking];
        NSNumber *onlinebankingSum = [billsForOnlinebanking valueForKeyPath:@"@sum.money.floatValue"];
        self.onlinebanking.text = [NSString stringWithFormat:@"%@: ¥%@", dag.billFlowTypeArray[3], onlinebankingSum.description];
        
        NSNumber *sum = [bills valueForKeyPath:@"@sum.money.floatValue"];
        self.summary.text = [@"总结: ¥" stringByAppendingString:sum.description];
        
        self.tips.hidden = YES;
        self.displayView.hidden = NO;
    } else {
        self.tips.hidden = NO;
        self.displayView.hidden = YES;
    }
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:M_Log_Out_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:KA_Request_Data_Notification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quiteOrDeleteLedger:) name:U_Http_Service_Quite_Ledger_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quiteOrDeleteLedger:) name:U_Http_Service_Delete_Ledger_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
