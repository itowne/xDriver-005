//
//  NewOilViewController.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/10.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "NewOilViewController.h"
#import "OilModel.h"
#import "DateUtil.h"

@interface NewOilViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentMileView;
@property (weak, nonatomic) IBOutlet UITextField *leftMileVIew;
@property (weak, nonatomic) IBOutlet UITextField *priceView;
@property (weak, nonatomic) IBOutlet UITextField *oilPlaceField;

- (IBAction)saveOil;

@end

@implementation NewOilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.currentMileView becomeFirstResponder];
}

- (IBAction)saveOil {
    NSLog(@"currentMile is %@, leftMile is %@, price is %@", self.currentMileView.text, self.leftMileVIew.text, self.priceView.text);
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(newOilViewController:saveOilModel:)]) {
        OilModel *oil = [[OilModel alloc] init];
        oil.currentMile = self.currentMileView.text;
        oil.leftMile = self.leftMileVIew.text;
        oil.oilPrice = self.priceView.text;
        oil.oilPlace = self.oilPlaceField.text;
        oil.oilTime = [DateUtil getCurrentDate];
        
        [self.delegate newOilViewController:self saveOilModel:oil];
    }
}
@end
