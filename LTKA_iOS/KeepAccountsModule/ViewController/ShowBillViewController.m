//
//  ShowBillViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/16.
//

#import "ShowBillViewController.h"
#import "Bill.h"
#import "HttpService.h"
#import "LTKAContext.h"
#import "DataArrayGetter.h"
#import "AddBillViewController.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface ShowBillViewController ()

@property (nonatomic, strong) Bill *bill;

@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *belong;
@property (nonatomic, strong) UILabel *details;
@property (nonatomic, strong) UILabel *billType;
@property (nonatomic, strong) UILabel *billConcreteType;
@property (nonatomic, strong) UILabel *billFlowType;
@property (nonatomic, strong) UILabel *realTime;

@property (nonatomic, strong) UIButton *modify;
@property (nonatomic, strong) UIButton *delete;

@end

@implementation ShowBillViewController

- (instancetype)initWithBillDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        _bill = [[Bill alloc] initWithDictionary:dict];
    }
    return self;
}

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
    
    UILabel *money = [UILabel new];
    [view addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _money = money;
    
    UILabel *belong = [UILabel new];
    [view addSubview:belong];
    [belong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(money.mas_bottom).offset(10);
    }];
    _belong = belong;
    
    UILabel *details = [UILabel new];
    [view addSubview:details];
    [details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(belong.mas_bottom).offset(10);
    }];
    _details = details;
    
    UILabel *billType = [UILabel new];
    [view addSubview:billType];
    [billType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(details.mas_bottom).offset(10);
    }];
    _billType = billType;
    
    UILabel *billConcreteType = [UILabel new];
    [view addSubview:billConcreteType];
    [billConcreteType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(billType.mas_bottom).offset(10);
    }];
    _billConcreteType = billConcreteType;
    
    UILabel *billFlowType = [UILabel new];
    [view addSubview:billFlowType];
    [billFlowType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(billConcreteType.mas_bottom).offset(10);
    }];
    _billFlowType = billFlowType;
    
    UILabel *realTime = [UILabel new];
    [view addSubview:realTime];
    [realTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(billFlowType.mas_bottom).offset(10);
    }];
    _realTime = realTime;
    
    UIView *btns = [UIView new];
    [view addSubview:btns];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(realTime.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    
    UIButton *modify = [UIButton new];
    [btns addSubview:modify];
    [modify setTitle:@"修改" forState:UIControlStateNormal];
    [modify setBackgroundColor:[UIColor grayColor]];
    [modify addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    [modify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.45);
        make.height.equalTo(btns);
        make.left.equalTo(btns.mas_left);
    }];
    _modify = modify;
    
    UIButton *delete = [UIButton new];
    [btns addSubview:delete];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete setBackgroundColor:[UIColor grayColor]];
    [delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.45);
        make.height.equalTo(btns);
        make.left.equalTo(modify.mas_right).offset(10);
        make.right.equalTo(btns.mas_right);
    }];
    _delete = delete;
    
    [self setup];
}

- (void)setup {
    self.money.text = [@"金额：" stringByAppendingString:self.bill.money];
    self.belong.text = [@"所属人：" stringByAppendingString:self.bill.belongUserId == [LTKAContext shareInstance].user.userId ? @"我" : self.bill.belong];
    self.details.text = [@"备注：" stringByAppendingString:self.bill.details];
    self.billType.text = [@"类型：" stringByAppendingString:[DataArrayGetter shareInstance].billTypeArray[self.bill.billType]];
    self.billConcreteType.text = [@"具体类型：" stringByAppendingString:[DataArrayGetter shareInstance].billConcreteTypeArray[self.bill.billConcreteType]];
    self.billFlowType.text = [@"出入帐方式：" stringByAppendingString:[DataArrayGetter shareInstance].billFlowTypeArray[self.bill.billFlowType]];
    self.realTime.text = [@"时间：" stringByAppendingString:self.bill.realTime];
}

- (void)modifyClick {
    if([self check]) {
        AddBillViewController *abvc = [AddBillViewController new];
        abvc.isAdd = NO;
        abvc.billId = self.bill.billId;
        [self.navigationController pushViewController:abvc animated:YES];
    }
}

- (void)deleteClick {
    if([self check]) {
        [[HttpService shareInstance] deleteBillServiceWithBillId:self.bill.billId];
    }
}

- (BOOL)check {
    if(self.bill.belongUserId == [LTKAContext shareInstance].user.userId || [LTKAContext shareInstance].user.conpetence == ConpetenceType_creator) {
        return YES;
    } else {
        [WHToast showMessage:@"操作失败，权限不足" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
        return NO;
    }
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyOrDeleteBillFinished:) name:U_Http_Service_Modify_Bill_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyOrDeleteBillFinished:) name:U_Http_Service_Delete_Bill_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)modifyOrDeleteBillFinished:(NSNotification *)notification {
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
