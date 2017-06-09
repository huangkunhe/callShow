//
//  BlackListViewController.m
//  callShow
//
//  Created by river on 2017/4/5.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "BlackListViewController.h"
#import "NSString+PhoneNumber.h"

@interface BlackListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) NSMutableArray * Numbernarry;
@property (nonatomic, strong) UILabel* NostrangNumlbl;//没有黑名单

@end

@implementation BlackListViewController

- (NSMutableArray *)Numbernarry
{
    if (!_Numbernarry) {
        _Numbernarry = [[NSMutableArray alloc] init];
    }
    return _Numbernarry;
}


- (UILabel *)NostrangNumlbl
{
    if (!_NostrangNumlbl) {
        _NostrangNumlbl = [[UILabel alloc] init];
        _NostrangNumlbl.frame=CGRectMake(0,tkScreenHeight/2-15,tkScreenWidth,30);
        
        _NostrangNumlbl.textAlignment=NSTextAlignmentCenter;
        _NostrangNumlbl.text=@"当前未添加黑名单";
        _NostrangNumlbl.textColor=[UIColor colorWithLongHex:0xa6a6a6];
        _NostrangNumlbl.font=[UIFont systemFontOfSize:14];
        _NostrangNumlbl.hidden=YES;
    }
    return _NostrangNumlbl;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tkScreenWidth, tkScreenHeight-64) style:UITableViewStylePlain];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.tableFooterView = [[UIView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.showsVerticalScrollIndicator=NO;
        
    }
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableview.backgroundColor=[UIColor colorWithLongHex:0xf5f5f5];
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"黑名单";
    // 导航栏右边编辑按钮
    self.navigationItem.rightBarButtonItems = [UIHelper createBarButtonItem:@"添加" setTarget:self setAction:@selector(addBlackPhone)];
     self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.NostrangNumlbl];
    [self addBanner];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self GETnumberarr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview数据源代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark ----选中的行 要执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.Numbernarry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierID];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithLongHex:0x3c3c3c];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl=[[UILabel  alloc]initWithFrame:CGRectMake(tkScreenWidth-80, 15, 70, 20)];
        lbl.textColor=kGrayTextColor;
        lbl.font=[UIFont systemFontOfSize:15];
        lbl.tag =100001;
        [cell.contentView addSubview:lbl];
        
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    if (self.Numbernarry.count > 0) {
        SCPhoneNumber *numInfo = self.Numbernarry[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"+%@", numInfo.phone];
        UILabel *label = [cell viewWithTag:100001];
        label.text = numInfo.mark;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {//删除样式
        [tableView endEditing:YES];
        //处理数据源
       [self deleteBlackListNumber:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)GETnumberarr{
    if (self.Numbernarry.count>0) {
        [self.Numbernarry removeAllObjects];
    }
    self.Numbernarry=[[[TeleInterceptionSDK new]getAllBlackNumber] mutableCopy];
    if (self.Numbernarry.count>0) {
        self.NostrangNumlbl.hidden=YES;
        self.tableview.hidden=NO;
        [self.tableview reloadData];
    }else{
        self.NostrangNumlbl.hidden=NO;
        self.tableview.hidden=YES;
    }
}

-(void)addBlackPhone{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"输入黑名单号码" preferredStyle:UIAlertControllerStyleAlert];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString* pasteStr = [[[pasteboard string] stripSpecicalPrefix] plainPhoneNumber];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"手机(电话)号码";
        textField.keyboardType=UIKeyboardTypePhonePad;
        if (pasteStr.length > 0 && [pasteStr isValidateMobile]) {
            textField.text = pasteStr;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *phoneTXT = alertController.textFields.firstObject.text;
        NSString* pasteStr = [[phoneTXT stripSpecicalPrefix] plainPhoneNumber];
        BOOL OK=[[TeleInterceptionSDK new] markBlackCallNumber:pasteStr withInfo:@"黑名单"];
        if(OK)
        {   [self reloadExtension];
            [self GETnumberarr];
        }else
        {
             [self showTextOnly:@"添加黑名单失败，请重新添加"];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    okAction.enabled =[pasteStr isValidateMobile];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
   //添加黑名单联系人
    
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *phoneTXT = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = [phoneTXT.text isValidateMobile] ;
    }
}

- (void)deleteBlackListNumber:(NSIndexPath *)indexPath {
    SCPhoneNumber *numInfo = [self.Numbernarry objectAtIndex:indexPath.row];
    BOOL OK=[[TeleInterceptionSDK new]unMarkBlackCallNumber:numInfo.phone];
    if (OK) {
        [self reloadExtension];
        [self.Numbernarry removeObjectAtIndex:indexPath.row];
        if (self.Numbernarry.count>0) {
            self.NostrangNumlbl.hidden=YES;
            [self.tableview reloadData];
        }else{
            self.NostrangNumlbl.hidden=NO;
            self.tableview.hidden=YES;
        }
        return;
    }else
        [self showTextOnly:@"删除黑名单失败，请重新删除"];
}

-(void)reloadExtension
{
    [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:tkBlackListKey completionHandler:^(NSError * _Nullable error) {
        if (error) {
            DLog(@"relaodCallBlockInfo error:%@", error.description);
            [UserDefaults setObject:@(YES) forKey:kReloadBlockInfoErrorKey];
            [UserDefaults synchronize];
        } else {
            [UserDefaults setObject:@(NO) forKey:kReloadBlockInfoErrorKey];
            [UserDefaults synchronize];
        }
    }];
}



@end
