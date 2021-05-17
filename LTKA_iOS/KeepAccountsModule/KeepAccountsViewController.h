//
//  KeepAccountsViewController.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeepAccountsViewController : UIViewController

// 表格
@property (nonatomic, strong) UITableView *tableView;
// 数组
@property (nonatomic, strong) NSMutableArray *dataArray;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
