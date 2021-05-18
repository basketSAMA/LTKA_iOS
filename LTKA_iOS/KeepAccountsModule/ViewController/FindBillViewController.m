//
//  FindBillViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/16.
//

#import "FindBillViewController.h"
#import "KeepAccountsViewController.h"

#import "Bill.h"
#import "TimeGetter.h"
#import "HttpService.h"
#import "LTKAContext.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface FindBillViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *belong;
@property (nonatomic, strong) UITextField *details;
@property (nonatomic, strong) UIDatePicker *realTime;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation FindBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    UITextField *belong = [UITextField new];
    [view addSubview:belong];
    belong.delegate = self;
    belong.clearButtonMode = UITextFieldViewModeAlways;
    belong.placeholder = @"所属人(模糊匹配)";
    belong.returnKeyType = UIReturnKeyDone;
    [belong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _belong = belong;
    
    UITextField *details = [UITextField new];
    [view addSubview:details];
    details.delegate = self;
    details.clearButtonMode = UITextFieldViewModeAlways;
    details.placeholder = @"备注(模糊匹配)";
    details.returnKeyType = UIReturnKeyDone;
    [details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(belong.mas_bottom).offset(10);
    }];
    _details = details;
    
    UIDatePicker *realTime = [UIDatePicker new];
    [view addSubview:realTime];
    realTime.datePickerMode = UIDatePickerModeDate;
    NSDate *maxDate = [NSDate date];
    realTime.maximumDate = maxDate;
    realTime.date = maxDate;
    [realTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(details.mas_bottom).offset(10);
    }];
    _realTime = realTime;
    
    UIButton *btn = [UIButton new];
    [view addSubview:btn];
    
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.centerX.equalTo(view);
        make.top.equalTo(realTime.mas_bottom).offset(10);
        make.bottom.equalTo(view.mas_bottom);
    }];
    _btn = btn;
}

- (void)btnClick {
    Bill *bill = [Bill new];
    bill.belong = self.belong.text;
    bill.details = self.details.text;
    bill.realTime = [[TimeGetter shareInstance] dateStrWithDateFormat:@"YYYY-MM-dd" andDate:self.realTime.date];
    [[HttpService shareInstance] searchBillServiceWithBill:bill andCompletedBlock:^(NSInteger code, NSString * _Nonnull msg, NSArray<Bill *> * _Nonnull ledgerArray) {
        [WHToast showMessage:msg originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
        if(code == 0) {
            [[KeepAccountsViewController shareInstance].dataArray removeAllObjects];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"realTime" ascending:NO];
            [[KeepAccountsViewController shareInstance].dataArray addObjectsFromArray:[ledgerArray sortedArrayUsingDescriptors:@[descriptor]]];
            [[KeepAccountsViewController shareInstance].tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
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
