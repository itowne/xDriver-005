//
//  EditOilViewController.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "EditOilViewController.h"
#import "OilModel.h"
#import "DateUtil.h"

@interface EditOilViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;//编辑选线
@property (weak, nonatomic) IBOutlet UITextField *currentMileField;//加油时里程
@property (weak, nonatomic) IBOutlet UITextField *leftMileField;//剩余里程
@property (weak, nonatomic) IBOutlet UITextField *oilPriceField;//加油金额
@property (weak, nonatomic) IBOutlet UILabel *oilTimeField;//加油时间
@property (weak, nonatomic) IBOutlet UIButton *chooseDataPickerBtn;

@property (weak, nonatomic) IBOutlet UITextField *oilPlaceField;//加油地点
@property (weak, nonatomic) IBOutlet UITextField *sinceLastDayField;//距离上次加油天数
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backAndSaveItem;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;//时间选择器View
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;//时间选择器


- (IBAction)chooseDatePicker;
- (IBAction)editItemAction:(UIBarButtonItem *)sender;//编辑按钮
- (IBAction)datePickerCancel;
- (IBAction)datePickerOk;
- (IBAction)backAndSaveItemAction:(UIBarButtonItem *)sender;



@end

@implementation EditOilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //textField数据初始化
    [self initOilData];

    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification{
    //TextField加入监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.currentMileField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.leftMileField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.oilPriceField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.oilTimeField];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.oilPlaceField];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.sinceLastDayField];
}

/**
 * 监听文本变化
 **/
- (void)textChange{
    if (self.currentMileField.enabled) {// 处于编辑状态
        self.backAndSaveItem.enabled = (self.currentMileField.text.length && self.leftMileField.text.length && self.oilPriceField.text.length);
        //让DatePickerView消失
        [self changeDatePickerViewStatus:YES];
    }
}

/**
 * 初始化OilModel数据
 **/
- (void)initOilData{
    self.currentMileField.text = _oil.currentMile;
    self.leftMileField.text = _oil.leftMile;
    self.oilPriceField.text = _oil.oilPrice;
    self.oilTimeField.text = _oil.oilTime;
    self.oilPlaceField.text = _oil.oilPlace;
    self.sinceLastDayField.text = _oil.sinceLastDay;
}

- (IBAction)chooseDatePicker {
    //取消键盘
    [self.currentMileField becomeFirstResponder];
    [self.currentMileField resignFirstResponder];
    
    [self changeDatePickerViewStatus:NO];
    [self.datePicker setDate:[DateUtil getDateByString:self.oilTimeField.text]];
}

- (IBAction)editItemAction:(UIBarButtonItem *)sender {
    if (self.currentMileField.enabled) {//编辑状态
        self.editItem.title = @"编辑";//改成非编辑状态的文字：编辑
        //改变backAndSave的文字
        self.backAndSaveItem.title = @"返回";
        
        [self changeTextFileEnableStatus:NO];
        
        [self changeDatePickerViewStatus:YES];
        
    } else {//当前为查看状态
        self.editItem.title = @"取消";//非编辑状态下，改变文件为：取消，进入编辑状态
        //改变backAndSave的文字
        self.backAndSaveItem.title = @"保存";
        [self changeTextFileEnableStatus:YES];
        //把第一个textField变为焦点，获取键盘
        [self.currentMileField becomeFirstResponder];
    }
    
}

/**
 * 改变所有TextField的可用状态
 **/
- (void) changeTextFileEnableStatus:(BOOL)isEnable{
    self.currentMileField.enabled = isEnable;
    self.leftMileField.enabled = isEnable;
    self.oilPriceField.enabled = isEnable;
    self.chooseDataPickerBtn.enabled = isEnable;
    self.oilPlaceField.enabled = isEnable;
    self.sinceLastDayField.enabled = isEnable;
}

/**
 * 改变DatePickerView的状态
 **/
- (void)changeDatePickerViewStatus:(BOOL)isHidden{
    self.datePickerView.hidden = isHidden;
}

- (IBAction)datePickerCancel {
    [self changeDatePickerViewStatus:YES];
}

- (IBAction)datePickerOk {
    //取消DatePickerView
    [self changeDatePickerViewStatus:YES];
    
    //设置数据
    self.oilTimeField.text = [DateUtil getStringByDate:[self.datePicker date]];
}

- (IBAction)backAndSaveItemAction:(UIBarButtonItem *)sender {
    //返回列表菜单
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.backAndSaveItem.title isEqualToString: @"保存"]) {
        _oil.currentMile = self.currentMileField.text;
        _oil.leftMile = self.leftMileField.text;
        _oil.oilPrice = self.oilPriceField.text;
        _oil.oilTime = self.oilTimeField.text;
        _oil.oilPlace = self.oilPlaceField.text;
        _oil.sinceLastDay = self.sinceLastDayField.text;
        
        if ([self.delegate respondsToSelector:@selector(editOilViewController:saveOilModel:)]) {
            [self.delegate editOilViewController:self saveOilModel:_oil];
        }
    }
}
@end
