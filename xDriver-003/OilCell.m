//
//  OilCell.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "OilCell.h"
#import "OilModel.h"

@interface OilCell()
@property (weak, nonatomic) IBOutlet UILabel *totalMile;
@property (weak, nonatomic) IBOutlet UILabel *oilTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *leftMile;
@property (weak, nonatomic) IBOutlet UILabel *currentMile;
@property (nonatomic, weak) UIView *devider;
@end

@implementation OilCell

- (void)awakeFromNib {
    UIView *devider = [[UIView alloc] init];
    devider.backgroundColor = [UIColor blackColor];
    devider.alpha = 0.3;
    
    [self.contentView addSubview:devider];
    self.devider = devider;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置分割线的frame
    CGFloat deviderX = 5;
    CGFloat deviderH = 1;
    CGFloat deviderY = self.frame.size.height - deviderH;
    CGFloat deviderW = self.frame.size.width - 10;
    self.devider.frame = CGRectMake(deviderX, deviderY, deviderW, deviderH);
}

+ (instancetype)oilWithTableView:(UITableView *)tableView{
    static NSString *ID = @"oil";
    OilCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}

- (void)setOil:(OilModel *)oil{
    _oil = oil;
    self.totalMile.text = [NSString stringWithFormat:@"%@公里", oil.oilMile];
    self.oilTime.text = oil.oilTime;
    self.price.text = [NSString stringWithFormat:@"%@元", oil.oilPrice];
    self.leftMile.text = [NSString stringWithFormat:@"%@公里", oil.leftMile];
    self.currentMile.text = [NSString stringWithFormat:@"%@公里", oil.currentMile];
}

@end
