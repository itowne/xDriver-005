//
//  OnDrivingViewController.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/8.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MileModel, OnDrivingViewController;

@protocol OnDrivingViewControllerDelegate<NSObject>

@optional
- (void)onDrivingViewController:(OnDrivingViewController *)onDrivingVc didAddMileData:(MileModel *)mileModel;

@end

@interface OnDrivingViewController : UIViewController

@property (nonatomic, strong) MileModel *mileModel;//模型数据

//设置代理
@property (nonatomic, weak) id<OnDrivingViewControllerDelegate> delegate;

@end
