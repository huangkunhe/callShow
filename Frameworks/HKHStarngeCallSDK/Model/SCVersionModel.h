//
//  SCVersionModel.h
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SCModel.h"

@interface SCVersionModel : SCModel

@property (nonatomic, strong) NSNumber * version;
@property (nonatomic, copy)   NSString *downurl;
@property (nonatomic, strong)   NSDate *updatedate;

SCVersionModel *initSCVersionModel(NSNumber *version, NSString *downurl, NSDate *updatedate);

@end
