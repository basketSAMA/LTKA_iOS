//
//  AddBillViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/15.
//

#import "AddBillViewController.h"
#import "LTKAContext.h"
#import "HttpService.h"
#import "DataArrayGetter.h"
#import "TimeGetter.h"
#import "Bill.h"
#import "LTKAAlert.h"

#import <Masonry/Masonry.h>
#import <WHToast/WHToast.h>

@interface AddBillViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *money;
@property (nonatomic, strong) UITextField *details;
@property (nonatomic, strong) UIPickerView *types;
@property (nonatomic, strong) UIDatePicker *realTime;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation AddBillViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        // 默认为添加账单
        _isAdd = YES;
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
    
    UITextField *money = [UITextField new];
    [view addSubview:money];
    money.delegate = self;
    money.clearButtonMode = UITextFieldViewModeAlways;
    money.placeholder = @"金额";
    money.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    money.returnKeyType = UIReturnKeyDone;
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(view.mas_top);
    }];
    _money = money;
    
    UITextField *details = [UITextField new];
    [view addSubview:details];
    details.clearButtonMode = UITextFieldViewModeAlways;
    details.placeholder = @"备注";
    details.returnKeyType = UIReturnKeyDone;
    [details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view).multipliedBy(0.9);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(view);
        make.top.equalTo(money.mas_bottom).offset(10);
    }];
    _details = details;
    
    UIPickerView *types = [UIPickerView new];
    [view addSubview:types];
    types.delegate = self;
    types.dataSource = self;
    [types mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(details.mas_bottom).offset(10);
    }];
    _types = types;
    
    UIDatePicker *realTime = [UIDatePicker new];
    [view addSubview:realTime];
    realTime.datePickerMode = UIDatePickerModeDateAndTime;
    NSDate *maxDate = [NSDate date];
    realTime.maximumDate = maxDate;
    realTime.date = maxDate;
    [realTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(types.mas_bottom).offset(10);
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
    if([@"" isEqualToString:self.money.text]) {
        [WHToast showMessage:@"金额不能为空" originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
        return;
    }
    NSString *realMoney = [self.types selectedRowInComponent:0] == BillType_income ? self.money.text : [@"-" stringByAppendingString:self.money.text];
    User *user = [LTKAContext shareInstance].user;
    Bill *bill = [[Bill alloc] initWithBelong:user.userName andBelongUserId:user.userId andDetails:self.details.text andRealTime:[[TimeGetter shareInstance] dateStrWithDateFormat:@"YYYY-MM-dd HH:mm" andDate:self.realTime.date] andMoney:realMoney andBillType:[self.types selectedRowInComponent:0] andBillConcreteType:[self.types selectedRowInComponent:1] andBillFlowType:[self.types selectedRowInComponent:2]];
    // 防止循环引用造成内存泄漏
    __weak typeof(self) weakSelf = self;
    [LTKAAlert showAlertWithTitle:@"提示" message:@"确定提交账单吗？" confirmHandle:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(strongSelf.isAdd) {
            [[HttpService shareInstance] addBillServiceWithBill:bill];
        } else {
            bill.billId = strongSelf.billId;
            [[HttpService shareInstance] modifyBillServiceWithBill:bill];
        }
    } cancleHandle:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0) {
        return [DataArrayGetter shareInstance].billTypeArray.count;
    } else if(component == 1) {
        return [DataArrayGetter shareInstance].billConcreteTypeArray.count;
    } else if(component == 2) {
        return [DataArrayGetter shareInstance].billFlowTypeArray.count;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) {
        return [DataArrayGetter shareInstance].billTypeArray[row];
    } else if(component == 1) {
        return [DataArrayGetter shareInstance].billConcreteTypeArray[row];
    } else if(component == 2) {
        return [DataArrayGetter shareInstance].billFlowTypeArray[row];
    } else {
        return @"";
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //限制只能输入数字
    BOOL isHaveDot = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDot = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            if([textField.text length] == 0) {
                if(single == '.' || single == '0') {
                    [WHToast showMessage:@"请输入正确的金额" originY:[[LTKAContext shareInstance] toastY] duration:1 finishHandler:nil];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDot) {
                    //text中还没有小数点
                    isHaveDot = YES;
                    return YES;
                } else {
                    [WHToast showMessage:@"请输入正确的金额" originY:[[LTKAContext shareInstance] toastY] duration:1 finishHandler:nil];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                //存在小数点
                if (isHaveDot) {
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    } else {
                        [WHToast showMessage:@"请输入正确的金额" originY:[[LTKAContext shareInstance] toastY] duration:1 finishHandler:nil];
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {
            //输入的数据格式不正确
            [WHToast showMessage:@"请输入正确的金额" originY:[[LTKAContext shareInstance] toastY] duration:1 finishHandler:nil];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrModifyBillFinished:) name:U_Http_Service_Add_Bill_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrModifyBillFinished:) name:U_Http_Service_Modify_Bill_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 广播响应事件
- (void)addOrModifyBillFinished:(NSNotification *)notification {
    NSInteger code = ((NSNumber *)notification.userInfo[@"code"]).integerValue;
    [WHToast showMessage:notification.userInfo[@"msg"] originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    if(code == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
