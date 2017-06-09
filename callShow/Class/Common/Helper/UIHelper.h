
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

@interface UIHelper : NSObject

/**
 *  创建纯文字Button
 *
 *  @param frame  位置参数
 *  @param title  标题内容
 *  @param size   标题文字大小
 *  @param target 事件监听对象
 *  @param action SEL事件回调方法
 *
 *  @return Button
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame setTitle:(NSString *)title
                            setSize:(CGFloat)size setTarget:(id)target setAction:(SEL)action;

////////////////////////////////////////////////////////////////////////////////////

/**
 *  创建导航栏item
 *
 *  @param frame  位置参数
 *  @param title  标题内容
 *  @param size   标题文字大小
 *  @param colors 颜色值数组(默认、高亮和选中状态颜色值)
 *  @param target 事件监听对象
 *  @param action SEL事件回调方法
 *
 *  @return item
 */
+ (UIBarButtonItem *)createBarButtonItemWithFrame:(CGRect)frame setTitle:(NSString *)title setSize:(CGFloat)size setColor:(NSArray *)colors setTarget:(id)target setAction:(SEL)action;

/**
 *  创建导航栏文字item(文字颜色/大小/位置设置默认值)
 *
 *  @param title  按钮标题内容
 *  @param target 事件监听对象
 *  @param action SEL事件回调方法
 *
 *  @return item数组
 */
+ (NSArray *)createBarButtonItem:(NSString *)title setTarget:(id)target setAction:(SEL)action;

/**
 *  创建导航栏图片item
 *
 *  @param imageName            默认图片名称
 *  @param highlightedImageName 高亮图片名称
 *  @param frame                位置参数
 *  @param target               事件监听对象
 *  @param action               SEL事件回调方法
 *
 *  @return item数组
 */
+ (NSArray *)createBarButtonItemWithNormalImage:(NSString *)imageName
                               highlightedImage:(NSString *)highlightedImageName setFrame:(CGRect)frame
                                      setTarget:(id)target withAction:(SEL)action;


+ (NSArray *)createBarButtonItemWith:(id)target withAddAction:(SEL)addAction withEditAction:(SEL)editAction;
+ (NSArray *)createBarButtonItemWith:(id)target withAddAction:(SEL)addAction withSortAction:(SEL)editAction;
+ (NSArray *)createBarButtonItemWith:(id)target withEditAction:(SEL)addAction withSortAction:(SEL)sortAction;

////////////////////////////////////////////////////////////////////////////////////


/**
 *  创建常规Lable
 *
 *  @param frame 位置参数
 *  @param size  字体大小
 *
 *  @return Label
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame setSize:(CGFloat)size;

////////////////////////////////////////////////////////////////////////////////////

/**
 *  创建表视图
 *
 *  @param frame    位置参数
 *  @param delegate 代理对象
 *  @param style    UITableViewStyle
 *
 *  @return 表视图
 */
+ (UITableView *)createTableViewWith:(CGRect)frame setDelegate:(id)delegate setStyle:(UITableViewStyle)style;


@end
