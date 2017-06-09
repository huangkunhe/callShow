
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "UIHelper.h"

@implementation UIHelper


#pragma mark 创建纯文字Button
+ (UIButton *)createButtonWithFrame:(CGRect)frame setTitle:(NSString *)title
                            setSize:(CGFloat)size setTarget:(id)target setAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - item相关方法
#pragma mark 创建导航栏位置分隔item
+ (UIBarButtonItem *)createFixedSpaceItem
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    CGFloat width = 0;
    if (IS_IOS7_OR_LATER) {
        width = -9;
    }
    fixedSpace.width = width;
    
    return fixedSpace;
}

#pragma mark 创建导航栏item
+ (UIBarButtonItem *)createBarButtonItemWithFrame:(CGRect)frame setTitle:(NSString *)title setSize:(CGFloat)size setColor:(NSArray *)colors setTarget:(id)target setAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:colors[0] forState:UIControlStateNormal];
    [button setTitleColor:colors[1] forState:UIControlStateHighlighted];
    [button setTitleColor:colors[1] forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark 创建导航栏文字item(文字颜色/大小/位置设置默认值)
+ (NSArray *)createBarButtonItem:(NSString *)title setTarget:(id)target setAction:(SEL)action
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [self createFixedSpaceItem];
    
    CGRect frame = CGRectMake(0, 0, 45.0, 44.0);
    UIColor *stateNormalColor = [UIColor whiteColor];
    UIColor *stateHighlightedColor = [UIColor whiteColor];
    UIBarButtonItem *item = [self createBarButtonItemWithFrame:frame setTitle:title setSize:17.0f setColor:@[stateNormalColor,stateHighlightedColor] setTarget:target setAction:action];
    return @[fixedSpace,item];
}

#pragma mark 创建导航栏图片item
+ (NSArray *)createBarButtonItemWithNormalImage:(NSString *)imageName
                               highlightedImage:(NSString *)highlightedImageName setFrame:(CGRect)frame
                                      setTarget:(id)target withAction:(SEL)action
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    if (!IS_IOS7_OR_LATER) {
        fixedSpace.width = 8;
    }
    if (IS_IPHONE6_PLUS) {
        fixedSpace.width = -8;
    }
    UIButton *button = [self createButtonWithNormalImage:imageName highlightedImage:highlightedImageName];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    return @[fixedSpace,item];
}

#pragma mark 创建导航栏上传按钮+更多
+ (NSArray *)createBarButtonItemWith:(id)target withAddAction:(SEL)addAction withEditAction:(SEL)editAction
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    if (!IS_IOS7_OR_LATER) {
        fixedSpace.width = 8;
    }
    if (IS_IPHONE6_PLUS) {
        fixedSpace.width = -8;
    }
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target: nil                                                                         action: nil];
    fixedButton.width=16;
    CGRect frame = CGRectMake(0, 0, 45.0, 44.0);
    UIButton *button = [self createButtonWithNormalImage:@"bt_uploading_normal.png" highlightedImage:@"bt_uploading_press.png"];
    button.frame = frame;
    [button sizeToFit];
    [button addTarget:target action:addAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button2 = [self createButtonWithNormalImage:@"bt_more_normal.png"
                                         highlightedImage:@"bt_more_press.png"];
    button2.frame = frame;
    [button2 sizeToFit];
    [button2 addTarget:target action:editAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];

    return @[fixedSpace,item2,fixedButton,item1];
    
}

#pragma mark 创建导航栏上传按钮+排序
+ (NSArray *)createBarButtonItemWith:(id)target withAddAction:(SEL)addAction withSortAction:(SEL)sortAction
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    if (!IS_IOS7_OR_LATER) {
        fixedSpace.width = 8;
    }
    if (IS_IPHONE6_PLUS) {
        fixedSpace.width = -8;
    }
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target: nil                                                                         action: nil];
    fixedButton.width=16;

    CGRect frame = CGRectMake(0, 0, 45.0, 44.0);
    UIButton *button = [self createButtonWithNormalImage:@"bt_sort_normal.png" highlightedImage:@"bt_sort_press.png"];
    button.frame = frame;
    [button sizeToFit];
    [button addTarget:target action:sortAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * sortItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if(addAction!=nil)
    {
        UIButton *button2 = [self createButtonWithNormalImage:@"bt_uploading_normal.png" highlightedImage:@"bt_uploading_press.png"];
        button2.frame = frame;
        [button2 sizeToFit];
        [button2 addTarget:target action:addAction forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
        return @[fixedSpace,sortItem,fixedButton,addItem];
        
    }
    return @[fixedSpace,sortItem];
}

#pragma mark 创建导航栏编辑按钮+排序
+ (NSArray *)createBarButtonItemWith:(id)target withEditAction:(SEL)addAction withSortAction:(SEL)sortAction
{
    // 导航栏item间隔
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    if (!IS_IOS7_OR_LATER) {
        fixedSpace.width = 8;
    }
    if (IS_IPHONE6_PLUS) {
        fixedSpace.width = -8;
    }
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target: nil                                                                         action: nil];
    fixedButton.width=16;
    
    CGRect frame = CGRectMake(0, 0, 48.0, 48.0);
    UIButton *button = [self createButtonWithNormalImage:@"bt_sort_normal.png" highlightedImage:@"bt_sort_press.png"];
    button.frame = frame;
    [button sizeToFit];
    [button addTarget:target action:sortAction forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * sortItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if(addAction!=nil)
    {
        UIButton *button2 = [self createButtonWithNormalImage:@"bt_choice_normal.png" highlightedImage:@"bt_choice_press.png"];
        button2.frame = frame;
        [button2 sizeToFit];
        [button2 addTarget:target action:addAction forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
        return @[fixedSpace,sortItem,fixedButton,addItem];
        
    }
    return @[fixedSpace,sortItem];
}

#pragma mark 创建常规Lable
+ (UILabel *)createLabelWithFrame:(CGRect)frame setSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - 表视图相关方法
#pragma mark 创建表视图
+ (UITableView *)createTableViewWith:(CGRect)frame setDelegate:(id)delegate setStyle:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

+ (UIButton *)createButtonWithNormalImage:(NSString *)imageName highlightedImage:(NSString *)highlightedImageName
{
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    return button;
}

@end
