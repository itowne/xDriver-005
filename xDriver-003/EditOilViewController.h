//
//  EditOilViewController.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OilModel, EditOilViewController;

@protocol EditOilViewControllerDelegate<NSObject>

@optional
- (void)editOilViewController:(EditOilViewController *)editVc saveOilModel:(OilModel *)oil;

@end

@interface EditOilViewController : UIViewController

@property (nonatomic, weak) OilModel *oil;
@property (nonatomic, weak) id<EditOilViewControllerDelegate> delegate;

@end
