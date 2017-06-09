
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

// 设置单元格默认高度
#define tkSettingCellHeight 47.0f

// 设置单元格左边距
#define tkSettingCellLeftGap 12.0f

@class SettingListCell;
@protocol SettingListCellDelegate <NSObject>
@optional
- (void)controlListenerWithButton:(UIControl *)button operateFromCell:(SettingListCell *)cell;
@end

typedef void(^controlListenerHandler)(UIButton *button, UIEvent *event);

@class SettingButton;
@interface SettingListCell : UITableViewCell

@property (nonatomic, assign, getter = isFirstCell) BOOL firstCell;  // 标记第一个Cell
@property (nonatomic, assign, getter = isLastCell) BOOL lastCell;    // 标记最后一个Cell
@property (nonatomic, strong) SettingModel *data;                    // 数据字典

@property (nonatomic, weak) id<SettingListCellDelegate>delegate;     // 协议对象
@property (nonatomic, weak, readonly) UILabel *rightLabel;           // 右边文本控件 (例如可设置“版本”文本)
@property (nonatomic, weak, readonly) UISwitch *rightSwitch;         // 右边开关控件 (例如可设置“传输加密”开关状态)
@property (nonatomic, weak, readonly) SettingButton *rightButton;    // 右边按钮控件 (例如可设置“清除缓存”按钮标题)

@end
