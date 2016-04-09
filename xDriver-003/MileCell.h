//
//  MileCell.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MileModel;

@interface MileCell : UITableViewCell

@property (nonatomic, strong) MileModel *mile;
+ (instancetype) mileWithTableView:(UITableView *)tableView;

@end
