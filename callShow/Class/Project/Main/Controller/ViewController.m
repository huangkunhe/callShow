//
//  ViewController.m
//  callShow
//
//  Created by river on 2017/2/8.
//  Copyright © 2017年 richinfo. All rights reserved.
//
#import <CallKit/CallKit.h>
#import "ViewController.h"
#import "CSHeaderView.h"
#import "SettingListCell.h"
#import "SettingModel.h"
#import "HelpViewController.h"
#import "BlackListViewController.h"
#import "SetViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,CSHeaderViewDelegate,SettingListCellDelegate>

@property(strong,nonatomic)UITableView * csTableView;

@property(nonatomic,strong)CSHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *data;       // 默认数据

@property(nonatomic,assign)BOOL isFirst;

@property(nonatomic,assign)BOOL isUpdating;

@property(nonatomic,copy)NSString * titlestr;

@end

@implementation ViewController

@synthesize titlestr=_titlestr;

-(NSString *)titlestr{
    return _titlestr;
}

-(void)setTitlestr:(NSString *)titlestr{
    _titlestr =[titlestr copy];
}

-(UITableView *)csTableView
{
    if (_csTableView == nil) {
        _csTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -(tkScreenHeight/2), tkScreenWidth, tkScreenHeight*2-80)];
        _csTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _csTableView.tableFooterView = [[UIView alloc] init];
        _csTableView.delegate =self;
        _csTableView.dataSource=self;
    }
    return _csTableView;
}

-(CSHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView =[[CSHeaderView alloc]initWithFrame:CGRectMake(0,0, tkScreenWidth, tkScreenHeight)];
        _headerView.delegate=self;
        if (self.isFirst) {
            [_headerView showWaveView];
        }else
        {
            [_headerView showRadarScannedView];
        }
    }
    return _headerView;
}


-(NSMutableArray *)data
{
    if (_data == nil) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tkSetting" ofType:@"plist"];
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
                mode.opne =[newDic[@"open"] boolValue];
                [newArr addObject:mode];
            }
            [_data addObject:newArr];
        }
    }
    return _data;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.interstitial load];
    self.title = @"通话助手";
    [self.view addSubview:self.csTableView];
    // 1、检查号码库 2、标识是否已开启（yes 进，no 帮助界面）3 、黑名单是否已经（yes 进，no 帮助界面）【 4、号码举报 5、标识查询 （logo）】
    //设置  wifi自动更新，帮助，版本信息【分享】【】后续版本
    
    [self addBanner];
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    self.navigationItem.rightBarButtonItems = [UIHelper createBarButtonItemWithNormalImage:@"setting_account_default" highlightedImage:@"setting_account_default" setFrame:CGRectMake(0, 0, 24, 24) setTarget:self withAction:@selector(help)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setFirstTime];
    [self checkUpdate];
    [self checkStangeCallMarkStatus:tkCallMarkKey];
    
}

- (void)dealloc
{
    // 移除控制器通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)help{
    
    NSLog(@"set");
    SetViewController * setVC = [SetViewController new];
    setVC.backButton =YES;
    [self.navigationController pushViewController:setVC animated:YES];
    
}


-(void)updateUI{

    [self checkStangeCallMarkStatus:tkCallMarkKey];
    
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
    static NSString *identify = @"SettingListCell";
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
    return 57;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return tkScreenHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didselect");
    if (indexPath.section ==0 && indexPath.row ==0) {
        SettingModel * model =self.data[0][0];
        if (model.opne) {
            [self updateData];
        }
        return;
    }
//    if (indexPath.section==0 && indexPath.row ==1) {
//        SettingModel * model =self.data[0][0];
//        if (!model.opne) {
//            BlackListViewController * blackVC = [BlackListViewController new];
//            blackVC.backButton =YES;
//            [self.navigationController pushViewController:blackVC animated:YES];
//        }
//        return;
//    }
}

#pragma mark CSHeaderViewDelegate
-(void)chickDownDelegate:(tkDownStatus)status
{
    if (!self.isUpdating) {
        return;
    }
    [self updateData];
}

#pragma mark SettingListCellDelegate

-(void)controlListenerWithButton:(UIControl *)button operateFromCell:(SettingListCell *)cell{
    if (!cell.data.opne) {
        HelpViewController *helpVC = [HelpViewController new];
        helpVC.dissmButton =YES;
        HKHNavigationController *navVC = [[HKHNavigationController alloc] initWithRootViewController:helpVC];
        [self.navigationController presentViewController:navVC animated:YES completion:nil];
        return;
    }
    if ([cell.data.titleName isEqualToString:@"身份识别"]) {
        cell.rightSwitch.on=YES;
        return;
    }
    if ([cell.data.titleName isEqualToString:@"黑名单"]) {
        [self checkStangeCallMarkStatus:tkBlackListKey];
    }
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.csTableView)
    {
        CGFloat sectionHeaderHeight = tkScreenHeight; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - function
- (void)checkStangeCallMarkStatus:(NSString *)callMarkIdentifier
{
    tkBlockSet
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:callMarkIdentifier completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        tkBlockGet(Self)
        if (enabledStatus != CXCallDirectoryEnabledStatusEnabled) {
            if ([callMarkIdentifier isEqualToString:tkCallMarkKey]) {
                SettingModel * model = Self.data[0][1];
                model.opne =YES;
                model.text =@"已开启";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Self.csTableView reloadData];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BlackListViewController * blackVC = [BlackListViewController new];
                    blackVC.backButton =YES;
                    [Self.navigationController pushViewController:blackVC animated:YES];
            });
            return;
                
            }
        }else
        {
            if ([callMarkIdentifier isEqualToString:tkCallMarkKey]) {
                SettingModel * model = Self.data[0][1];
                model.opne =NO;
                model.text =@"未开启";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Self.csTableView reloadData];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    HelpViewController *helpVC = [HelpViewController new];
                    helpVC.dissmButton =YES;
                    HKHNavigationController *navVC = [[HKHNavigationController alloc] initWithRootViewController:helpVC];
                    [Self.navigationController presentViewController:navVC animated:YES completion:nil];
                });
            }
            
        }
        
    }];
    
}

- (void)checkStangeCallMarkStatus2:(NSString *)callMarkIdentifier
{
    tkBlockSet
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:callMarkIdentifier completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        tkBlockGet(Self)
        if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
            if ([callMarkIdentifier isEqualToString:tkCallMarkKey]) {
                SettingModel * model = Self.data[0][1];
                model.opne =YES;
                model.text =@"已开启";
            }else
            {
                SettingModel * model = Self.data[0][2];
                model.opne =YES;
                model.text =@" ";
                
            }
        }else
        {
            if ([callMarkIdentifier isEqualToString:tkBlackListKey]) {
                SettingModel * model = Self.data[0][1];
                model.opne =NO;
                model.text =@"未开启";
            }else
            {
                SettingModel * model = Self.data[0][2];
                model.opne =NO;
                model.text =@"未开启";
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Self.csTableView reloadData];
        });
        
    }];
    
}

-(void)checkUpdate
{
    BOOL isAuto =[UserDefaults objectForKey:kAutoDown] ? [[UserDefaults objectForKey:kAutoDown] boolValue] : NO;
    
    
    
    tkBlockSet
    [[TeleInterceptionSDK new] isNeedUpdateStrangeCallsCompletion:^(BOOL result, NSString *path) {
        tkBlockGet(Self)
        NSDictionary *resultObj = [NSDictionary dictionaryWithContentsOfFile:path];
        if (resultObj[@"isOpneAD"] !=nil) {
            
            [UserDefaults setObject:@([resultObj[@"isOpneAD"] boolValue])forKey:kIsOpenAD];
            [self addBanner];
        }
        
        SettingModel *model = Self.data[0][0];
        if (result) {
            if (Self.isFirst) {
                
                [Self updateData];
            }else
            {
                [HKHReachabilityHelper currentReachabilityStatus:^(NetworkStatus status) {
                    if (status ==ReachableViaWiFi) {
                        if (isAuto) {
                             [Self updateData];
                        }
                    }
                }];
                model.imageName=@"icon_new_version";
                model.opne =YES;
            }
        }else
        {
            if (self.isFirst) {
                
                [Self updateData];
            }
            model.imageName =@"";
            model.opne =NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Self.csTableView reloadData];
        });
        
    } onError:^(NSInteger code, NSString *message) {
        return;
    }];
}

-(void)updateData
{
    self.isUpdating =YES;
    tkBlockSet
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headerView showWaveView];
    });
    
    [[TeleInterceptionSDK new] updateStrangeCallsWithSuccess:^{
        tkBlockGet(Self)
        [Self reloadExtension];
        [Self.headerView showRadarScannedView];
        SettingModel *model = Self.data[0][0];
        model.imageName =@"";
        model.opne =NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [Self.csTableView reloadData];
        });
        self.isUpdating =NO;
        NSLog(@"下载成功，进行扫描保护");
        
    } withFailure:^(NSInteger code, NSString *message) {
        [self.headerView showWaveView];
        [self.headerView setDownStatus:tkDownReady];
        self.isUpdating =NO;
        [self showTextOnly:@"更新数据库号码失败，请重新点击下载"];
        NSLog(@"失败");
        
    } withProgress:^(double progress) {
        tkBlockGet(strongSelf)
        if (progress< 0) {
            progress=0.5;
        }
        NSLog(@"%f",progress*100);
        [strongSelf.headerView setDownStatus:tkDowning];
        [strongSelf.headerView setPrecent:progress*100];
        
    }];
    
}

-(void)setFirstTime{
    NSString *version =[[NSUserDefaults standardUserDefaults]stringForKey:didShowTutorialKey];
    if (version==nil ||![version isEqualToString:KBundleVersion]) {
        self.isFirst =YES;
        [[NSUserDefaults standardUserDefaults] setObject:KBundleVersion forKey:didShowTutorialKey];
        return;
    }
    self.isFirst =NO;
}

-(void)reloadExtension
{
    [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:tkCallMarkKey completionHandler:^(NSError * _Nullable error) {
        if (error) {
            DLog(@"relaodCallBlockInfo error:%@", error.description);
            [UserDefaults setObject:@(YES) forKey:kReloadMarkInfoErrorKey];
            [UserDefaults synchronize];
        } else {
            [UserDefaults setObject:@(NO) forKey:kReloadMarkInfoErrorKey];
            [UserDefaults synchronize];
        }
    }];
}

@end
