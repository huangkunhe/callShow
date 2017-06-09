//
//  SetViewController.m
//  callShow
//
//  Created by river on 2017/4/15.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SetViewController.h"
#import "SettingListCell.h"
#import "SettingModel.h"
#import "HelpViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,SettingListCellDelegate>

@property(strong,nonatomic)UITableView * setTableView;

@property (nonatomic, strong) NSMutableArray *data;       // 默认数据

@end

@implementation SetViewController

-(UITableView *)setTableView
{
    if (_setTableView == nil) {
        _setTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tkScreenWidth, tkScreenHeight)];
        _setTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _setTableView.tableFooterView = [[UIView alloc] init];
        _setTableView.delegate =self;
        _setTableView.dataSource=self;
    }
    return _setTableView;
}

-(NSMutableArray *)data
{
    if (_data == nil) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tkUserSetting" ofType:@"plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
        _data = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (int i=0; i<[data count]; i++)
        {
            NSArray *rows = data[i];
            NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:[rows count]];
            for (NSDictionary *dic in rows) {
                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                SettingModel * mode = [SettingModel new];
                mode.titleName = newDic[@"titleName"];
                mode.style = [(NSString *)newDic[@"style"] integerValue];
                mode.text =newDic[@"text"];
                if ([mode.titleName isEqualToString:@"WIFI自动下载号码库"]) {
                    mode.opne=[UserDefaults objectForKey:kAutoDown] ? [[UserDefaults objectForKey:kAutoDown] boolValue] : NO;
                }
                [newArr addObject:mode];
            }
            [_data addObject:newArr];
        }
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.setTableView];
    [self addBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 协议相关方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"SettingCell";
    SettingListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[SettingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    cell.data = self.data[section][row];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark SettingListCellDelegate

-(void)controlListenerWithButton:(UIControl *)button operateFromCell:(SettingListCell *)cell{
    
    if ([cell.data.titleName isEqualToString:@"使用说明"]) {
        HelpViewController *helpVC = [HelpViewController new];
        helpVC.dissmButton =YES;
        HKHNavigationController *navVC = [[HKHNavigationController alloc] initWithRootViewController:helpVC];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        return;
    }
    if ([cell.data.titleName isEqualToString:@"WIFI自动下载号码库"]) {
        
        [UserDefaults setObject:@(cell.rightSwitch.on) forKey:kAutoDown];
        [UserDefaults synchronize];
    }
    
}

@end
