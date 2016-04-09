//
//  OnDrivingViewController.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/8.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "OnDrivingViewController.h"
#import "MileModel.h"
#import "DateUtil.h"
#import "NSCodingUtil.h"

@interface OnDrivingViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *startMileLable;
- (IBAction)cancelDriving:(UIBarButtonItem *)sender;
- (IBAction)finishDriving;


@end

@implementation OnDrivingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //保存当前状态为正在行驶
    [NSCodingUtil setIsOnDriving:YES];
    [NSCodingUtil setIsOnDrivingMileModel:self.mileModel];
    
    self.startMileLable.text = [NSString stringWithFormat:@"%@公里", self.mileModel.startMile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 * 返回上一个界面
 **/
- (IBAction)cancelDriving:(UIBarButtonItem *)sender {
    UIAlertView *cancelView = [[UIAlertView alloc] initWithTitle:nil message:@"确认取消？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [cancelView show];
}

/**
 * 处理UIAlertView的逻辑
 **/
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    //不管alertViewStyle是0还是1都是要返回上一个界面
    [self.navigationController popViewControllerAnimated:YES];
    //alertViewStyle=2表示结束行程,确认结束的里程数
    if (alertView.alertViewStyle == 2){
        if ([self.delegate respondsToSelector:@selector(onDrivingViewController:didAddMileData:)]) {
            //1. 获取结束的里程数
            self.mileModel.endMile = [alertView textFieldAtIndex:0].text;
            self.mileModel.endTime = [DateUtil getCurrentDate];
            
            //2. 跳转刚到上个界面
            [self.delegate onDrivingViewController:self didAddMileData:self.mileModel];
        }
    }
        
    //保存当前状态为正在行驶
    [NSCodingUtil setIsOnDriving:NO];
}

/**
 * 结束行程
 **/
- (IBAction)finishDriving {
    UIAlertView *finishView = [[UIAlertView alloc] initWithTitle:@"请输入结束里程" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    finishView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [finishView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [finishView show];
}
@end
