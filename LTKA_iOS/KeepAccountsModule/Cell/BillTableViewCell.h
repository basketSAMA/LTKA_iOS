//
//  BillTableViewCell.h
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/3.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

NS_ASSUME_NONNULL_BEGIN

#define KA_Bill_Cell_Identifier_income @"KeepAccountsBillCellIdentifierIncome"
#define KA_Bill_Cell_Identifier_expenditure @"KeepAccountsBillCellIdentifierExpenditure"

@interface BillTableViewCell : UITableViewCell

@property (nonatomic, strong) Bill *bill;

@end

NS_ASSUME_NONNULL_END
