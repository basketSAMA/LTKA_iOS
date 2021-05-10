//
//  KeepAccountsViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/23.
//

#import "KeepAccountsViewController.h"

#import "Bill.h"
#import "BillGroup.h"
#import "TimeGetter.h"
#import "BillTableViewCell.h"
#import "LTKAContext.h"

@interface KeepAccountsViewController () <UITableViewDelegate, UITableViewDataSource>

// 表格
@property (nonatomic, strong) UITableView *tableView;
// 数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *label;

@end

@implementation KeepAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"记账";
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Register_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Log_In_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:M_Log_Out_Notification object:nil];
    
    [self.view addSubview:self.label];
    [self.label setFrame:self.view.bounds];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BillTableViewCell class] forCellReuseIdentifier:KA_Bill_Cell_Identifier_income];
    [self.tableView registerClass:[BillTableViewCell class] forCellReuseIdentifier:KA_Bill_Cell_Identifier_expenditure];
    
    [self setup];
}

- (void) setup {
    LTKAContext *context = [LTKAContext shareInstance];
    if(!context.isLogIn) {
        self.label.text = @"未登录";
        self.label.hidden = NO;
        self.tableView.hidden = YES;
    } else if(context.user.conpetence == ConpetenceType_nil) {
        self.label.text = @"未创建或加入账本";
        self.label.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        [self requestData];
        self.tableView.hidden = NO;
        self.label.hidden = YES;
    }
}

#pragma mark - Array初始化
// 测试数据
//- (void) initData {
//    for(int i = 0; i < 10; i++) {
//        [self.dataArray addObject:[[Bill alloc] initWithBelong:@"我" andDetails:@"" andRealTime:nil andMoney:@"20.00" andBillType:i%2 andBillConcreteType:BillConcreteType_eating andBillFlowType:BillFlowType_alipay]];
//    }
//}
- (void) requestData {
    
}

#pragma mark - 懒加载
- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        
        // 去掉所有表格线
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self; //遵循协议
        _tableView.dataSource = self; //遵循数据源
    }
    return _tableView;
}
- (NSMutableArray *) dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];//初始化数组
    }
    return _dataArray;
}
- (UILabel *) label {
    if(_label == nil) {
        _label = [UILabel new];
    }
    return _label;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
//分区，组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
// 设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//每个单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Bill *bill = self.dataArray[indexPath.row];
    BillTableViewCell *billTableViewCell = nil;
    if(bill.billType == BillType_income) {
        billTableViewCell = [tableView dequeueReusableCellWithIdentifier:KA_Bill_Cell_Identifier_income forIndexPath:indexPath];
    }
    else if(bill.billType == BillType_expenditure) {
        billTableViewCell = [tableView dequeueReusableCellWithIdentifier:KA_Bill_Cell_Identifier_expenditure forIndexPath:indexPath];
    }
    
    if(billTableViewCell == nil) {
        if(bill.billType == BillType_income) {
            billTableViewCell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KA_Bill_Cell_Identifier_income];
        }
        else if(bill.billType == BillType_expenditure) {
            billTableViewCell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KA_Bill_Cell_Identifier_expenditure];
        }
    }
    
    [billTableViewCell setBill:bill];

    return billTableViewCell;
}
#pragma mark - 广播
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
