//
//  KeepAccountsViewController.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/23.
//

#import "KeepAccountsViewController.h"
#import "JoinLedgerViewController.h"
#import "AddBillViewController.h"
#import "ShowBillViewController.h"
#import "FindBillViewController.h"

#import "Bill.h"
#import "BillGroup.h"
#import "TimeGetter.h"
#import "BillTableViewCell.h"
#import "LTKAContext.h"
#import "HttpService.h"

#import <WHToast/WHToast.h>
#import <VHBoomMenuButton/VHBoomMenuButton.h>

@interface KeepAccountsViewController () <UITableViewDelegate, UITableViewDataSource>

// 异常状态文字
@property (nonatomic, strong) UILabel *label;
// 悬浮菜单按钮
@property (nonatomic, strong) VHBoomMenuButton *bmb1;
@property (nonatomic, strong) VHBoomMenuButton *bmb2;

@end

@implementation KeepAccountsViewController

+ (instancetype)shareInstance {
    static KeepAccountsViewController *kavc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kavc = [[KeepAccountsViewController alloc] init];
    });
    return kavc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"记账";
    // Do any additional setup after loading the view.
    
    [self addObservers];
    
    CGFloat statusBarHeight;
    CGFloat bottomSafeHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0 ? 34 : 0;
    if(@available(iOS 13.0, *)) {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    CGRect screenFrame = CGRectMake(self.view.bounds.origin.x + 0,
                                    self.view.bounds.origin.y + statusBarHeight + 44,
                                    self.view.bounds.size.width,
                                    self.view.bounds.size.height - statusBarHeight - 44 - 49 - bottomSafeHeight);
    [[LTKAContext shareInstance] setScreenFrame:screenFrame];
    [[LTKAContext shareInstance] setToastY:self.view.bounds.size.height - 44 - 49 - 40];
    
    // 背景图片（导航栏有毛玻璃效果）
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shuimo"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imgView];
    
    [self.view addSubview:self.label];
    [self.label setFrame:screenFrame];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:screenFrame];
    [self.tableView registerClass:[BillTableViewCell class] forCellReuseIdentifier:KA_Bill_Cell_Identifier_income];
    [self.tableView registerClass:[BillTableViewCell class] forCellReuseIdentifier:KA_Bill_Cell_Identifier_expenditure];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shuimo"]];
//    imgView.frame = screenFrame;
//    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.tableView.backgroundView = imgView;
    
    //下拉刷新
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:control];
    
    CGFloat bmbRadius = 60;
    [self.view addSubview:self.bmb1];
    [self.bmb1 setFrame:CGRectMake(screenFrame.origin.x + screenFrame.size.width - 20 - bmbRadius,
                                   screenFrame.origin.y + screenFrame.size.height - 20 - bmbRadius,
                                   bmbRadius,
                                   bmbRadius)];
    self.bmb1.buttonEnum = VHButtonHam;
    self.bmb1.piecePlaceEnum = VHPiecePlaceHAM_2;
    self.bmb1.buttonPlaceEnum = VHButtonPlaceHAM_2;
    NSArray *imgs1 = @[@"create_ledger", @"join_ledger"];
    NSArray *texts1 = @[@"创建账本", @"加入账本"];
    [self.bmb1 clearBuilders];
    for (int i = 0; i < self.bmb1.pieceNumber; i++) {
        VHHamButtonBuilder *builder = [VHHamButtonBuilder builder];
        builder.clickedBlock = ^(int index) {
            if(index == 0) {
                [[HttpService shareInstance] createLedgerServiceWithbelongUserId:[[LTKAContext shareInstance] user].userId];
            } else if(index == 1) {
                [self.navigationController pushViewController:[JoinLedgerViewController new] animated:YES];
            }
        };
        builder.normalImageName = imgs1[i];
        builder.imageSize = CGSizeMake(45, 45);
        builder.normalText = texts1[i];
//            builder.normalSubText = @"Sub Text";
        [self.bmb1 addBuilder:builder];
    }
    
    [self.view addSubview:self.bmb2];
    [self.bmb2 setFrame:CGRectMake(screenFrame.origin.x + screenFrame.size.width - 20 - bmbRadius,
                                   screenFrame.origin.y + screenFrame.size.height - 20 - bmbRadius,
                                   bmbRadius,
                                   bmbRadius)];
    self.bmb2.buttonEnum = VHButtonTextInsideCircle;
    self.bmb2.piecePlaceEnum = VHPiecePlaceDOT_5_1;
    self.bmb2.buttonPlaceEnum = VHButtonPlaceSC_5_1;
    NSArray *imgs2 = @[@"add_bill", @"search_bill", @"quite_ledger", @"delete_ledger", @"copy_code"];
    NSArray *texts2 = @[@"添加账单", @"查找账单", @"退出账本", @"删除账本", @"复制序列号"];
    [self.bmb2 clearBuilders];
    for (int i = 0; i < self.bmb2.pieceNumber; i++) {
        VHTextInsideCircleButtonBuilder *builder = [VHTextInsideCircleButtonBuilder builder];
        builder.clickedBlock = ^(int index) {
            if(index == 0) {
                [self.navigationController pushViewController:[AddBillViewController new] animated:YES];
            } else if(index == 1) {
                [self.navigationController pushViewController:[FindBillViewController new] animated:YES];
            } else if(index == 2) {
                User *user = [LTKAContext shareInstance].user;
                [[HttpService shareInstance] quiteLedgerServiceWithLedgerId:user.ledgerId andUserId:user.userId];
            } else if(index == 3) {
                User *user = [LTKAContext shareInstance].user;
                [[HttpService shareInstance] deleteLedgerServiceWithLedgerId:user.ledgerId andUserId:user.userId];
            } else if(index == 4) {
                [[HttpService shareInstance] checkSerialCodeServiceWithLedgerId:[LTKAContext shareInstance].user.ledgerId];
            }
        };
        builder.normalImageName = imgs2[i];
        builder.imageSize = CGSizeMake(45, 45);
        builder.normalText = texts2[i];
        [self.bmb2 addBuilder:builder];
    }
    
    [self setup];
}

- (void) setup {
    LTKAContext *context = [LTKAContext shareInstance];
    if(!context.isLogIn) {
        self.label.text = @"未登录";
        self.label.hidden = NO;
        self.tableView.hidden = YES;
        self.bmb1.hidden = YES;
        self.bmb2.hidden = YES;
    } else if(context.user.conpetence == ConpetenceType_nil) {
        self.label.text = @"未创建或加入账本";
        self.label.hidden = NO;
        self.tableView.hidden = YES;
        self.bmb1.hidden = NO;
        self.bmb2.hidden = YES;
    } else {
        [self requestData];
        self.label.hidden = YES;
        self.tableView.hidden = NO;
        self.bmb1.hidden = YES;
        self.bmb2.hidden = NO;
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
    [[HttpService shareInstance] getLedgerArrayServiceWithLedgerId:[[LTKAContext shareInstance] user].ledgerId andCompletedBlock:^(NSInteger code, NSString * _Nonnull msg, NSArray<Bill *> * _Nonnull ledgerArray) {
        if(code == 0) {
            [self.dataArray removeAllObjects];
//            [self.dataArray addObjectsFromArray:[[ledgerArray reverseObjectEnumerator] allObjects]];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"realTime" ascending:NO];
            [self.dataArray addObjectsFromArray:[ledgerArray sortedArrayUsingDescriptors:@[descriptor]]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:KA_Request_Data_Notification object:nil];
        } else {
            [WHToast showMessage:msg originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
            [LTKAContext shareInstance].user.conpetence = ConpetenceType_nil;
            [[HttpService shareInstance] ModifyUserService];
        }
        if([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }
    }];
}

#pragma mark - 懒加载
- (UITableView *) tableView {
    if (_tableView == nil) {
        _tableView = [UITableView new];
        
        // 去掉所有表格线
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self; //遵循协议
        _tableView.dataSource = self; //遵循数据源
        // 透明背景
        _tableView.backgroundColor = [UIColor clearColor];
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
- (VHBoomMenuButton *) bmb1 {
    if(_bmb1 == nil) {
        _bmb1 = [VHBoomMenuButton new];
    }
    return _bmb1;
}
- (VHBoomMenuButton *) bmb2 {
    if(_bmb2 == nil) {
        _bmb2 = [VHBoomMenuButton new];
    }
    return _bmb2;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
// 分区，组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
// 设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
// 每个单元格的内容
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
    // 透明背景
    billTableViewCell.backgroundColor = [UIColor clearColor];

    return billTableViewCell;
}

// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Bill *bill = self.dataArray[indexPath.row];
    ShowBillViewController *sbvc = [[ShowBillViewController alloc] initWithBillDict:[Bill billToDict:bill]];
    [self.navigationController pushViewController:sbvc animated:YES];
}

#pragma mark - 广播
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Register_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Log_In_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:M_Log_Out_Notification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Create_Ledger_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Join_Ledger_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quiteOrDeleteLedger:) name:U_Http_Service_Quite_Ledger_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quiteOrDeleteLedger:) name:U_Http_Service_Delete_Ledger_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSerialCode:) name:U_Http_Service_Check_Serial_Code_Notification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Add_Bill_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Delete_Bill_Notification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Modify_Bill_Notification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:U_Http_Service_Modify_User_Notification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 特殊广播响应事件
- (void)quiteOrDeleteLedger:(NSNotification *)notification {
    NSInteger code = ((NSNumber *)[notification.userInfo objectForKey:@"code"]).integerValue;
    NSString *msg = [notification.userInfo objectForKey:@"msg"];
    if(code == 0) {
        [self setup];
    } else {
        [WHToast showMessage:msg originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
    }
}

- (void)checkSerialCode:(NSNotification *)notification {
    NSInteger code = ((NSNumber *)[notification.userInfo objectForKey:@"code"]).integerValue;
    NSString *msg = [notification.userInfo objectForKey:@"msg"];
    if(code == 0) {
        NSString *serialCode = [notification.userInfo objectForKey:@"serialCode"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = serialCode;
    }
    [WHToast showMessage:msg originY:[[LTKAContext shareInstance] toastY] duration:2 finishHandler:nil];
}

@end
