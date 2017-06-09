
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

#import "SettingListCell.h"
#import "SettingButton.h"

#define tkRightWidth 100.0f

@interface SettingListCell ()

@end

@implementation SettingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置标题
    UILabel *titleLabel = (UILabel *)[self.contentView viewWithTag:201];
    titleLabel.text = _data.titleName;
    
    // 设置控件
    UILabel *styleDefault = (UILabel *)[self.contentView viewWithTag:301];
    UISwitch *styleSwitch = (UISwitch *)[self.contentView viewWithTag:302];
    SettingButton *styleArrow = (SettingButton *)[self.contentView viewWithTag:303];
    SettingButton *styleLabelAndArrow = (SettingButton *)[self.contentView viewWithTag:304];
    UIImageView *styleImageView = (UIImageView *)[self.contentView viewWithTag:305];
    
    int style = (int)_data.style;
    styleDefault.hidden = (style == tkSettingStyleDefault)?NO:YES;
    styleSwitch.hidden = (style == tkSettingStyleSwitch)?NO:YES;
    styleArrow.hidden = (style == tkSettingStyleArrow)?NO:YES;
    styleLabelAndArrow.hidden = (style == tkSettingStyleLabelAndArrow)?NO:YES;
    styleImageView.hidden= (style == tkSettingStyleImage)?NO:YES;
    
    styleDefault.text = _data.text;
    styleSwitch.on =_data.opne;
    [styleLabelAndArrow setTitle:_data.text forState:UIControlStateNormal];
    [styleImageView setImage:[UIImage imageNamed:_data.imageName]];

}

#pragma mark - 自定义方法
#pragma mark 初始化界面
- (void)initSubviews
{    
    // 样式设置
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.bounds;
    if (!IS_IOS7_OR_LATER) {
        // 清除iOS6分组表视图单元格画线
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        [backgroundView setBackgroundColor:[UIColor
                                            clearColor]];
        [self setBackgroundView:backgroundView];
    }
    
    frame = CGRectMake(0, 0, tkScreenWidth, tkSettingCellHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contentView];
    
    // 标题
    frame = CGRectMake(tkSettingCellLeftGap, (tkSettingCellHeight-20)/2.0,
                       tkScreenWidth-2*tkSettingCellLeftGap-tkRightWidth, 20.0);
    UILabel *titleLabel = [self createLabelWithFrame:frame setSize:16.0f];
    //titleLabel.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
    titleLabel.textColor = [UIColor colorWithLongHex:0x333333];
    titleLabel.tag = 201;
    [self.contentView addSubview:titleLabel];
    
    //////////////////////////////////////////////////////
    
    // 默认控件0
    frame = CGRectMake(titleLabel.right+5.0, (tkSettingCellHeight-40)/2.0, tkRightWidth-10.0, 40.0);
    UILabel *styleDefault = [self createLabelWithFrame:frame setSize:16.0];
    //styleDefault.backgroundColor = [UIColor cyanColor];
    styleDefault.textColor = [UIColor redColor];
    styleDefault.textAlignment = NSTextAlignmentRight;
    styleDefault.hidden = YES;
    styleDefault.tag = 301;
    styleDefault.text = @"V2.0.0";
    [self.contentView addSubview:styleDefault];
    _rightLabel = styleDefault;
    
    // 显示UISwitch控件1
    UISwitch *styleSwitch = [[UISwitch alloc] initWithFrame:frame];
    styleSwitch.onTintColor = KGreenStyleColor;
    styleSwitch.on = YES;
    styleSwitch.hidden = YES;
    styleSwitch.onImage=[UIImage imageNamed:@"bt_open"];
    styleSwitch.onImage=[UIImage imageNamed:@"bt_close"];
    styleSwitch.tag = 302;
    [styleSwitch addTarget:self action:@selector(buttonAction:withEvent:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:styleSwitch];
    styleSwitch.top = (tkSettingCellHeight-styleSwitch.height)/2.0;
    styleSwitch.left += tkRightWidth-10-styleSwitch.width;
    _rightSwitch = styleSwitch;
    
    // 显示箭头2
    frame.origin.x = tkSettingCellLeftGap;
    frame.size.width = tkScreenWidth-2*tkSettingCellLeftGap;
    SettingButton *styleArrow = [SettingButton buttonWithType:UIButtonTypeCustom];
    styleArrow.frame = frame;
    styleArrow.hidden = YES;
    styleArrow.tag = 303;
    [styleArrow addTarget:self action:@selector(buttonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:styleArrow];
    
    // 显示文本和箭头3
    SettingButton *styleLabelAndArrow = [SettingButton buttonWithType:UIButtonTypeCustom];
    styleLabelAndArrow.frame = frame;
    styleLabelAndArrow.hidden = YES;
    styleLabelAndArrow.tag = 304;
    [styleLabelAndArrow addTarget:self action:@selector(buttonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:styleLabelAndArrow];
    _rightButton = styleLabelAndArrow;
    
    //显示自定义图片
    frame = CGRectMake(titleLabel.right+tkRightWidth/2, (tkSettingCellHeight-10)/2.0, tkRightWidth/4, 15.0);
    UIImageView *imageView = [UIImageView new];
    imageView.frame = frame;
    imageView.hidden = YES;
    imageView.tag = 305;
    [self.contentView addSubview:imageView];
    
}

#pragma mark 分组表视图 调整iOS6单元格位置
- (void)setFrame:(CGRect)frame
{
    if (!IS_IOS7_OR_LATER) {
        CGFloat inset = -10.0f;
        frame.origin.x += inset;
        frame.size.width -= 2*inset;
    }
    [super setFrame:frame];
}

#pragma mark 按钮相关操作方法
- (void)buttonAction:(UIControl *)button withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(controlListenerWithButton:operateFromCell:)]) {
        [self.delegate controlListenerWithButton:button operateFromCell:self];
    }
}

- (UILabel *)createLabelWithFrame:(CGRect)frame setSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


@end
