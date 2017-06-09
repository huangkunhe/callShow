//
//  SettingModel.h
//  callShow
//
//  Created by river on 2017/4/2.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property(nonatomic,copy) NSString *imageName;
@property(nonatomic,copy) NSString *titleName;
@property(nonatomic,copy) NSString *text;
@property(nonatomic,assign)BOOL opne;
@property(nonatomic,assign) tkSettingStyle style;

@end
