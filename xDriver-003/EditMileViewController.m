//
//  EditMileViewController.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/13.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "EditMileViewController.h"
#import "MileModel.h"
#import "DateUtil.h"

@interface EditMileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *startMileView;//开始里程
@property (weak, nonatomic) IBOutlet UITextField *endMileView;//结束里程
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//结束时间
- (IBAction)chooseStartTime; //修改开始时间
- (IBAction)chooseEndTime; //修改结束时间

@property (weak, nonatomic) IBOutlet UIButton *chooseStartTimeBtn; //修改开始时间按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseEndTimeBtn;//修改结束时间按钮



- (IBAction)save; //保存动作
@property (weak, nonatomic) IBOutlet UIButton *saveBtn; //保存按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;//编辑按钮

- (IBAction)editAction:(UIBarButtonItem *)sender;//编辑动作

//时间选择器
@property (weak, nonatomic) IBOutlet UIView *DatePickerView; //时间选择面板
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;//时间选择器
- (IBAction)datePickerCancel;//取消时间选择
- (IBAction)datePickerSave;//确认时间选择
@property (nonatomic, assign) NSInteger chooseType;//1：开始时间； 2：结束时间

@end

@implementation EditMileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    self.startMileView.text = self.mile.startMile;
    self.endMileView.text = self.mile.endMile;
    self.startTimeLabel.text = self.mile.startTime;
    self.endTimeLabel.text = self.mile.endTime;
    
    //设置TextField的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.startMileView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.endMileView];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textChange{
    self.saveBtn.enabled = (self.startMileView.text.length && self.endMileView.text.length);
}

/**
 * 更改开始时间DatePicker
 **/
- (IBAction)chooseStartTime {
    [self checkChooseTime:self.startTimeLabel.text];
    
    self.chooseType = 1;
}

- (IBAction)chooseEndTime {
    
    [self checkChooseTime:self.endTimeLabel.text];
    
    self.chooseType = 2;
}

/**
 * 选择时间的设置
 **/
- (void)checkChooseTime:(NSString *) timeString{
    [self.startMileView resignFirstResponder];
    [self.endMileView resignFirstResponder];
    
    [self showDatePickerView];
    
    self.datePicker.date = [DateUtil getDateByString:timeString];
}

/**
 * 保存数据，并返回到前一个controller
 **/
- (IBAction)save {
    
    _mile.startMile = self.startMileView.text;
    _mile.endMile = self.endMileView.text;
    _mile.startTime = self.startTimeLabel.text;
    _mile.endTime = self.endTimeLabel.text;
    
    NSLog(@"-------save------, startTime is %@", _mile.startTime);
    
    //1. 返回前一个controller
    [self.navigationController popViewControllerAnimated:YES];
    
    //2. 让代理调用更新方法
    if ([self.delegate respondsToSelector:@selector(editMile:saveMileModel:)]) {
        [self.delegate editMile:self saveMileModel:_mile];
    }
    
}
- (IBAction)editAction:(UIBarButtonItem *)sender {
    
    if (self.startMileView.enabled) {
        self.editBtn.title = @"编辑";
        self.startMileView.enabled = NO;
        self.endMileView.enabled = NO;
        self.chooseStartTimeBtn.enabled = NO;
        self.chooseEndTimeBtn.enabled = NO;
        self.saveBtn.hidden = NO;
        self.DatePickerView.hidden = YES;
        
        //如果是点击取消，则要恢复数据
        self.startMileView.text = self.mile.startMile;
        self.endMileView.text = self.mile.endMile;
        self.startTimeLabel.text = self.mile.startTime;
        self.endTimeLabel.text = self.mile.endTime;
        
        
    }else {
        self.editBtn.title = @"取消";
        self.startMileView.enabled = YES;
        self.endMileView.enabled = YES;
        self.chooseStartTimeBtn.enabled = YES;
        self.chooseEndTimeBtn.enabled = YES;
        self.saveBtn.enabled = YES;
        [self.startMileView becomeFirstResponder];
    }

    
}
- (IBAction)datePickerCancel {
    self.DatePickerView.hidden = YES;
    self.saveBtn.hidden = NO;
}

- (IBAction)datePickerSave {
    NSString *dateStr = [DateUtil getStringByDate:self.datePicker.date];
    switch (self.chooseType) {
        case 1:
            self.startTimeLabel.text = dateStr;
            break;
        default:
            self.endTimeLabel.text = dateStr;
            break;
    }
    [self dismissDatePickerView];
}

/**
 * datepicker View消失后的处理
 **/
- (void) dismissDatePickerView{
    self.DatePickerView.hidden = YES;
    self.saveBtn.hidden = NO;
}

- (void) showDatePickerView{
    self.DatePickerView.hidden = NO;
    self.saveBtn.hidden = YES;
}

@end
