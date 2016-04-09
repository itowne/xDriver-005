//
//  NewOilViewController.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/10.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewOilViewController, OilModel;

@protocol NewOilViewControllerDelegate<NSObject>

@optional
- (void) newOilViewController:(NewOilViewController *)vc saveOilModel:(OilModel *)oil;

@end

@interface NewOilViewController : UIViewController

@property (nonatomic, weak) id<NewOilViewControllerDelegate> delegate;

@end
