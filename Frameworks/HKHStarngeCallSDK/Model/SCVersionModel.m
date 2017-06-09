//
//  SCVersionModel.m
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "SCVersionModel.h"

@implementation SCVersionModel

SCVersionModel *initSCVersionModel(NSNumber *version, NSString *downurl, NSDate *updatedate){
    SCVersionModel * model = [SCVersionModel new];
    model.version = version ;
    model.downurl = downurl;
    model.updatedate = updatedate;
    return model;
}

@end
