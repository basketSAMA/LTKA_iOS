//
//  BillTableViewCell.m
//  LTKA_iOS
//
//  Created by Qilan Huang on 2021/5/3.
//

#import "BillTableViewCell.h"
#import "DataArrayGetter.h"
#import "LTKAContext.h"

#import <Masonry/Masonry.h>

@interface BillTableViewCell ()

@property (nonatomic, weak) UIImageView *billConcreteTypeImageView; // 账单具体类型对应图标
@property (nonatomic, weak) UILabel *billConcreteTypeLabel;         // 账单具体类型
@property (nonatomic, weak) UILabel *moneyLabel;                    // 金额
@property (nonatomic, weak) UILabel *belongLabel;                   // 所属人

@end

@implementation BillTableViewCell

// 重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        if([reuseIdentifier isEqualToString:KA_Bill_Cell_Identifier_income]) {
            [self setupViewForIncome];
        }
        else if([reuseIdentifier isEqualToString:KA_Bill_Cell_Identifier_expenditure]) {
            [self setupViewForExpenditure];
        }
    }
    // 选中不变色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

// 添加子控件
- (void)setupViewForIncome {
    UIImageView *billConcreteTypeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:billConcreteTypeImageView];
    [billConcreteTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    self.billConcreteTypeImageView = billConcreteTypeImageView;
    
    UILabel *billConcreteTypeLabel = [[UILabel alloc] init];
    billConcreteTypeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:billConcreteTypeLabel];
    [billConcreteTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(billConcreteTypeImageView);
        make.right.equalTo(billConcreteTypeImageView.mas_left).with.offset(-5);
        make.height.mas_equalTo(22);
    }];
    self.billConcreteTypeLabel = billConcreteTypeLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(billConcreteTypeLabel);
        make.right.equalTo(billConcreteTypeLabel.mas_left).with.offset(-5);
        make.height.mas_equalTo(22);
    }];
    self.moneyLabel = moneyLabel;
    
    UILabel *belongLabel = [[UILabel alloc] init];
    belongLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:belongLabel];
    [belongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(billConcreteTypeImageView);
        make.right.equalTo(billConcreteTypeImageView.mas_left).with.offset(-5);
        make.height.mas_equalTo(22);
    }];
    self.belongLabel = belongLabel;
}

- (void)setupViewForExpenditure {
    UIImageView *billConcreteTypeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:billConcreteTypeImageView];
    [billConcreteTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    self.billConcreteTypeImageView = billConcreteTypeImageView;
    
    UILabel *billConcreteTypeLabel = [[UILabel alloc] init];
    billConcreteTypeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:billConcreteTypeLabel];
    [billConcreteTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(billConcreteTypeImageView);
        make.left.equalTo(billConcreteTypeImageView.mas_right).with.offset(5);
        make.height.mas_equalTo(22);
    }];
    self.billConcreteTypeLabel = billConcreteTypeLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(billConcreteTypeLabel);
        make.left.equalTo(billConcreteTypeLabel.mas_right).with.offset(5);
        make.height.mas_equalTo(22);
    }];
    self.moneyLabel = moneyLabel;
    
    UILabel *belongLabel = [[UILabel alloc] init];
    belongLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:belongLabel];
    [belongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(billConcreteTypeImageView);
        make.left.equalTo(billConcreteTypeImageView.mas_right).with.offset(5);
        make.height.mas_equalTo(22);
    }];
    self.belongLabel = belongLabel;
}

- (void)setBill:(Bill *)bill {
    if(_bill != bill) {
        _bill = bill;
    }
    self.billConcreteTypeImageView.image = [UIImage imageNamed:[[DataArrayGetter shareInstance] billConcreteTypeImageNameArray][bill.billConcreteType]];
    self.billConcreteTypeLabel.text = [[DataArrayGetter shareInstance] billConcreteTypeArray][bill.billConcreteType];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@", bill.money];
    self.belongLabel.text = bill.belongUserId == [LTKAContext shareInstance].user.userId ? @"我" : bill.belong;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
