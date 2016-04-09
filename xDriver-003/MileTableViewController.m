//
//  MileTableViewController.m
//  xDriver-003
//
//  Created by 林国强 on 15/6/7.
//  Copyright (c) 2015年 lynn. All rights reserved.
//

#import "MileTableViewController.h"
#import "MileModel.h"
#import "MileCell.h"
#import "OilCell.h"
#import "OnDrivingViewController.h"
#import "DateUtil.h"
#import "NSCodingUtil.h"
#import "OilCell.h"
#import "OilModel.h"
#import "NewOilViewController.h"
#import "EditMileViewController.h"
#import "EditOilViewController.h"
#import "MileSql.h"
#import "OilSQLite.h"
#import "RequestUtil.h"

@interface MileTableViewController ()<OnDrivingViewControllerDelegate, UIAlertViewDelegate, NewOilViewControllerDelegate, EditMileViewControllerDelegate, EditOilViewControllerDelegate>
//@property (nonatomic, strong) NSMutableArray *totalMiles;
@property (nonatomic, strong) NSMutableArray *oils;
@property (nonatomic, strong) NSArray *groupMiles;
@property (nonatomic, strong) MileModel *addMileModel;//新增的MileModel
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addMileBarItem;

- (IBAction)segmentedChoose:(id)sender;
- (IBAction)beginMile:(UIBarButtonItem *)sender;
@end

@implementation MileTableViewController

/**
 * 设置miles的模型信息
 **/
//-(NSArray *)totalMiles{
//    if (_totalMiles == nil) {
//        _totalMiles = [MileSql miles];
//    }
//    if (_totalMiles == nil) {
//        _totalMiles = [NSMutableArray array];
//    }
//    return _totalMiles;
//}

- (NSArray *)groupMiles{
    if (_groupMiles == nil) {
        _groupMiles = [MileSql selectMilesByDayGroup];
    }
    return _groupMiles;
}

/**
 * 新增一个MileModel
 **/
- (void) addMile:(MileModel *)mile{
    //将记录加到数据库
    [MileSql saveMileModel:mile];
    
    //重新分组
    _groupMiles = [MileSql selectMilesByDayGroup];
}

/**
 * 删除一个MileModel
 **/
- (void) deleteMile:(MileModel *)mile{
    //数据库中删除
    [MileSql deleteMileModel:mile.mileId];
    
//    [self.totalMiles removeObject:mile];
    //重新分组
    _groupMiles = [MileSql selectMilesByDayGroup];
}

- (void) updateMile:(MileModel *)mile{
    //数据库更新
    [MileSql updateMileModel:mile];
    
    //更新totalMile
    
    
    //重新分组
}

-(NSMutableArray *)oils{
    if (_oils == nil) {
//        _oils = [NSCodingUtil selectOilModels];
        //从数据库获取数据
        _oils = [OilSQLite oils];
    }
    
    if (_oils == nil) {
        _oils = [NSMutableArray array];
        
    }
    return _oils;
}

-(MileModel *)addMileModel{
//    NSLog(@"-(MileModel *)addMileModel");
    if (_addMileModel == nil) {
        _addMileModel = [[MileModel alloc] init];
    }
    return _addMileModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (MileModel *model in [MileSql miles]) {
//        [RequestUtil saveMileToServer:model];
//    }
    
    for (OilModel *model in [OilSQLite oils]) {
        [RequestUtil didOilToServer:model];
    }
    
    //检查是否有正在行驶，如果有则恢复数据
    if ([NSCodingUtil isOnDriving]) {
        //获取正在行驶的MileModel
        self.addMileModel = [NSCodingUtil isOnDrivingMileModel];
        //跳转到下个页面
        [self performSegueWithIdentifier:@"mile2OnDriving" sender:nil];
    }
    
    
}

/**
 * 有多少组
 **/
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger seg = self.segmentControl.selectedSegmentIndex;
    if (seg == 0) {
        NSLog(@"%%%%%%%%%%%%%%%%%%numberOfSectionsInTableView is %ld", self.groupMiles.count);
        //获取数据分组
        return self.groupMiles.count;
    }
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"numberOfRowsInSection");
    NSInteger segIndex = self.segmentControl.selectedSegmentIndex;
    if (segIndex == 0) {
        NSArray *group = nil;
        for (NSString *key in self.groupMiles[section]) {
//            NSLog(@"************** key is %@", key);
            group = [self.groupMiles[section] objectForKey:key];
        }
        return group.count;
    } else {
        return self.oils.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cellForRowAtIndexPath");
    NSInteger segIndex = self.segmentControl.selectedSegmentIndex;
    if (segIndex == 0) {
        MileCell *cell = [MileCell mileWithTableView:tableView];
        cell.mile = [self selectMileModelByIndexPath:indexPath];
        return cell;
    }else {
        OilCell *cell = [OilCell oilWithTableView:tableView];
        cell.oil = self.oils[indexPath.row];
        return cell;
    }
}

/**
 * 组的头标题
 **/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSInteger segIndex = self.segmentControl.selectedSegmentIndex;
    if (segIndex == 1) return nil;
    
    for (NSString *key in self.groupMiles[section]) {
        //统计单天的公里数
        NSArray *array = [self.groupMiles[section] valueForKey:key];
        int totalMile = 0;
        for (MileModel *mile in array) {
            totalMile += ([mile.endMile intValue] - [mile.startMile intValue]);
        }

        
        return [NSString stringWithFormat:@"%@(%@)---%d公里", key, [DateUtil getWeekByDate:[DateUtil getDateyString:key withFormatter:@"yyyy-MM-dd"]], totalMile];
    }
    return @"--";
}

/**
 *  如果实现了这个方法,就自动实现了滑动删除的功能
 *  点击了删除按钮就会调用
 *  提交了一个编辑操作就会调用(操作:删除\添加)
 *  @param editingStyle 编辑的行为
 *  @param indexPath    操作的行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是否删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据
        if (self.segmentControl.selectedSegmentIndex == 0) {
            
            MileModel *deleteMile = [self selectMileModelByIndexPath:indexPath];
            
            //删除操作
            [self deleteMile:deleteMile];
            
            //刷新数据
            NSLog(@"sections = %ld, groups = %ld", self.tableView.numberOfSections, self.groupMiles.count);

            if (self.tableView.numberOfSections != self.groupMiles.count) {//该分组的最后一条数据，则删除分组
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }else {
            OilModel *oilModel = self.oils[indexPath.row];
            [self.oils removeObjectAtIndex:indexPath.row];
            
            //刷新数据
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //保存数据
//            [NSCodingUtil saveOilModels:self.oils];
            //删除数据库数据
            [OilSQLite deleteOilModel:oilModel.oilId];
            
        }
        
    }
}

- (IBAction)segmentedChoose:(UISegmentedControl *)sender {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        self.tableView.rowHeight = 88;
    }else {
        self.tableView.rowHeight = 44;
    }
    [self.tableView reloadData];
}

#pragma alertView
- (IBAction)beginMile:(UIBarButtonItem *)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        UIAlertView *beginMile = [[UIAlertView alloc] initWithTitle:nil message:@"开始里程" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        beginMile.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *beginMileField = [beginMile textFieldAtIndex:0];
        beginMileField.keyboardType = UIKeyboardTypeDecimalPad;
        if (self.groupMiles.count > 0) {
            NSArray *group = nil;
            for (NSString *key in self.groupMiles[0]) {
                group = [self.groupMiles[0] objectForKey:key];
            }
            MileModel *mile = group[0];
            beginMileField.text = mile.endMile;
        }
        
        [beginMile show];
    }else {
//        NSLog(@"add oil......");
        [self performSegueWithIdentifier:@"oil2AddNew" sender:nil];
    }
    
}

/**
 * alertView代理
 **/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) return;
    //设置新增的MileModel值
    self.addMileModel = nil;
    self.addMileModel = [[MileModel alloc] init];
    self.addMileModel.startMile = [alertView textFieldAtIndex:0].text;
    self.addMileModel.startTime = [DateUtil getCurrentDate];
    [self performSegueWithIdentifier:@"mile2OnDriving" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //处理第一个segment， Mile
    if (self.segmentControl.selectedSegmentIndex == 0) {
        if ([vc isKindOfClass:[OnDrivingViewController class]]) {
            OnDrivingViewController *onDrivingVc = segue.destinationViewController;
            onDrivingVc.mileModel = self.addMileModel;
            
            //设置代理
            onDrivingVc.delegate = self;
        }else if ([vc isKindOfClass:[EditMileViewController class]]){
            EditMileViewController *editVc = segue.destinationViewController;
            editVc.mile = [self selectMileModelByIndexPath:indexPath];
            editVc.delegate = self;
        }
    }else {//处理第二个segment ， Oil
        if ([vc isKindOfClass:[NewOilViewController class]]) {
            NewOilViewController *newOilvc = segue.destinationViewController;
            newOilvc.delegate = self;
        } else if([vc isKindOfClass:[EditOilViewController class]]){
            EditOilViewController *editOilVc = segue.destinationViewController;
            editOilVc.oil = self.oils[indexPath.row];
            editOilVc.delegate = self;
        }
    }
}

/**
 *  根据IndexPath 查询指定的MileModel
 **/
- (MileModel *) selectMileModelByIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.groupMiles[indexPath.section];
    NSArray *group = nil;
    for (NSString *key in dict) {
        group = [dict objectForKey:key];
    }
    return group[indexPath.row];
}

#pragma OnDrvingViewController 代理方法
- (void)onDrivingViewController:(OnDrivingViewController *)onDrivingVc didAddMileData:(MileModel *)mileModel{
    //新增操作
    [self addMile:mileModel];
    
    [self.tableView reloadData];
}

#pragma NewOilViewController代理方法
- (void)newOilViewController:(NewOilViewController *)vc saveOilModel:(OilModel *)oil{
    
    OilModel *lastOil = self.oils[0];
    NSLog(@"上次加油时间：%@, 上次加油编号：%ld, 上次加油时的公里数：%@, 上次加油时剩余公里数：%@",
          lastOil.oilTime, lastOil.oilId, lastOil.currentMile, lastOil.leftMile);
    
    //上一次加油行驶路程等于：  本次加油时的里程 - 上次加油时的里程 - 上次剩余里程 + 本次剩余里程
    lastOil.oilMile = [NSString stringWithFormat:@"%ld", [oil.currentMile integerValue] - [lastOil.currentMile integerValue] - [lastOil.leftMile integerValue] + [oil.leftMile integerValue]];
    
    //保存到数据库
    [OilSQLite updateOilModel:lastOil];
    [OilSQLite saveOilModel:oil];
    
    self.oils = [OilSQLite oils];
    
    [self.tableView reloadData];
}

#pragma EditViewController代理方法
/**
 * 更新数据
 **/
- (void)editMile:(EditMileViewController *)editVc saveMileModel:(MileModel *)mile{
    //刷新数据
//    [NSCodingUtil saveMileModels:self.miles];
    //更新数据到数据库
    [MileSql updateMileModel:mile];
    [self.tableView reloadData];
}

#pragma EditOilViewController的代理方法
-(void) editOilViewController:(EditOilViewController *)editVc saveOilModel:(OilModel *)oil{
    //保存数据
//    [NSCodingUtil saveOilModels:_oils];
    [OilSQLite updateOilModel:oil];
    
    //刷新数据
    [self.tableView reloadData];
}

@end
