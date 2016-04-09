//
//  EditMileViewController.h
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditMileViewController, MileModel;

@protocol EditMileViewControllerDelegate<NSObject>

@optional
/**
 * 代理方法，更新修改后的MileModel
 **/
- (void)editMile:(EditMileViewController *) editVc saveMileModel:(MileModel *)mile;

@end

@class MileModel;
@interface EditMileViewController : UIViewController

@property (nonatomic, strong) MileModel *mile;
//代理属性
@property (nonatomic, weak) id<EditMileViewControllerDelegate> delegate;

@end
