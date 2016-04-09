//
//  MileCell.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "MileCell.h"
#import "MileModel.h"

@interface MileCell()
@property (weak, nonatomic) IBOutlet UILabel *startMileView;
@property (weak, nonatomic) IBOutlet UILabel *endMileView;
@property (weak, nonatomic) IBOutlet UILabel *mileView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeView;
@property (nonatomic, weak) UIView *devider;//底部分割线

@end

@implementation MileCell

- (void)awakeFromNib {
    //设置底部分割线的UIView
    UIView *devider = [[UIView alloc] init];
    devider.backgroundColor = [UIColor blackColor];
    devider.alpha = 0.3;
    
    //加入当前的contentView
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

+ (instancetype)mileWithTableView:(UITableView *)tableView{
    static NSString *ID = @"mile";
    MileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}

-(void) setMile:(MileModel *)mile{
    _mile = mile;
    self.startMileView.text = [NSString stringWithFormat:@"%@公里", mile.startMile];
    self.endMileView.text = [NSString stringWithFormat:@"%@公里", mile.endMile];
    self.mileView.text = [NSString stringWithFormat:@"%ld公里", [mile.endMile integerValue] - [mile.startMile integerValue]];
    self.startTimeView.text = mile.startTime;
    self.endTimeView.text = mile.endTime;
}

@end
