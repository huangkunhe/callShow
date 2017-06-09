//
//  SCPhoneNumber.h
//  callShow
//
//  Created by river on 2017/3/27.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SCModel.h"

@interface SCPhoneNumber : SCModel
@property (nonatomic, assign) long indexID;   // 索引电话
@property (nonatomic, copy) NSString *mark;     //标识
@property (nonatomic, strong) NSNumber *phone;    //电话
@property (nonatomic, copy) NSString *tagStr;    //标识
@property (nonatomic, copy) NSString *markNum;  //标识人数
@property (nonatomic, copy) NSString *source; //标识来源
@property (nonatomic, copy) NSString *logoStr;   //标识的logo

@end
