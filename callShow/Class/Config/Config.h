
// +----------------------------------------------------------------------
// | ThinkDrive [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2014 Richinfo. All rights reserved.
// +----------------------------------------------------------------------

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？


#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...)
#endif



//-----------------BASE Setting-----------------
#define tkScreenWidth [[UIScreen mainScreen] bounds].size.width
#define tkScreenHeight [[UIScreen mainScreen] bounds].size.height
#define tkVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define isVersionGreater(v) ([[[UIDevice currentDevice] systemVersion] floatValue] >= v ? YES : NO)

#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height > 480.0)?YES:NO
#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size):NO)

#define IS_IOS7_OR_LATER ((tkVersion >= 7.0) ? YES:NO)
#define IOS7_STATUS_BAR_HEIGHT (IS_IOS7_OR_LATER ? 20.0f:0.0f)
#define IS_IOS8_OR_LATER ((tkVersion >= 8.0) ? YES:NO)

#define IOS_STATUS_BAR_HEIGHT 20.0f
#define IOS_STATUS_AND_NAV_BAR_HEIGHT (IOS_STATUS_BAR_HEIGHT+44.0)

#define tkTranslucent YES    // YES导航栏半透明效果 NO则否
#define tkLayoutScreenHeight ((tkTranslucent && IS_IOS7_OR_LATER) ? tkScreenHeight:(tkScreenHeight-IOS_STATUS_AND_NAV_BAR_HEIGHT)) // 布局全屏高度
#define tkLayoutScreenTop ((tkTranslucent && IS_IOS7_OR_LATER) ? IOS_STATUS_AND_NAV_BAR_HEIGHT:0)  // 布局Y值

#define tkAnimateWithDuration 0.25f // 默认动画时间

#define tkPageViewTabHeight 45.0f   // Tab默认高度
#define tkPageViewTabWidth (tkScreenWidth/2.0) // Tab默认宽度
#define tkAdjustHeight (IOS_STATUS_AND_NAV_BAR_HEIGHT+tkPageViewTabHeight) // Tab控制器中调整的高度

//-----------------COLOR Setting-----------------
#define KGreenStyleColor [UIColor colorWithLongHex:0x02c969]
#define kGrayTextColor [UIColor colorWithLongHex:0xb8b8b8]
#define KBackgroundColor [UIColor colorWithLongHex:0xf8f8f8]
#define KGreenLabColor [UIColor colorWithLongHex:0x02c969]  //选中字体颜色



//-----------------ThemeManager-----------------
#define tkThemeDidChangeNotification @"tkThemeDidChangeNotification"
#define tkThemeName @"tkThemeName"
#define tkColor(r,g,b,a) [UIColor colorWithRed:r/250.0 green:g/250.0 blue:b/250.0 alpha:a]
#define tkNavigationBarTitleLabel @"tkNavigationBarTitleLabel"
#define tkThemeListLabel @"tkThemeListLabel"

//-----------------Common Func-----------------
#define tkBlockSet __weak __typeof(&*self)weakSelf = self;
#define tkBlockGet(name) __strong __typeof(&*self)name = weakSelf;

//-----------------发送通知-------------------


//-----------------常用提示用语-------------------
#define tkTipsWithoutTheInternet     @"世界上最遥远的距离就是没网络"
#define tkTipsOutOfWifiRange         @"目前处在非WIFI网络下，%@会消耗数据流量，是否继续？"

//-----------------用户常用设置-------------------
#define tkSortKey                    @"tkSortKey"
#define didShowTutorialKey           @"com.richinfo.callassistant_version"
#define KBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kAutoDown @"WIFIAUTODOWN"

#define kIsOpenAD @"IsOpenAD"

//#define kIsOpenADError ([UserDefaults objectForKey:kIsOpenAD] ? [[UserDefaults objectForKey:kIsOpenAD] boolValue] : NO)

#define kIsOpenADError YES

#define tkCallMarkKey                    @"com.richinfo.callassistant.callmark"

#define tkBlackListKey                    @"com.richinfo.callassistant.blacklist"

//Strange Calls

#define kReloadMarkInfoErrorKey @"ReloadMarkInfoErrorKey"
#define kReloadMarkInfoError ([UserDefaults objectForKey:kReloadMarkInfoErrorKey] ? [[UserDefaults objectForKey:kReloadMarkInfoErrorKey] boolValue] : NO)

#define kReloadBlockInfoErrorKey @"ReloadBlockInfoErrorKey"
#define kReloadBlockInfoError ([UserDefaults objectForKey:kReloadBlockInfoErrorKey] ? [[UserDefaults objectForKey:kReloadBlockInfoErrorKey] boolValue] : NO)


typedef NS_ENUM(NSInteger, tkSettingStyle) {
    tkSettingStyleDefault = 0,   // 默认显示文本
    tkSettingStyleSwitch,        // 显示UISwitch控件
    tkSettingStyleArrow,         // 显示箭头
    tkSettingStyleLabelAndArrow,  // 显示文本和箭头
    tkSettingStyleImage
};
//-----------------sdk-------------------dd61d413754c481eadb62943e523fa52
#define INMOBI_INITIALIZE   @"7f1da244c6874e699093c31324365e29"
#define INMOBI_INITIALIZE2  @"dd61d413754c481eadb62943e523fa52"
#define INMOBI_BANNERID   1493634387795
#define INMOBI_INTERSTITIALID   1492486126306


