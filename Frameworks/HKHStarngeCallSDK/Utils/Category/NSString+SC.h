//
//  NSString+SC.h
//  callShow
//
//  Created by river on 2017/3/24.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SC)

// NSString+PJR相关
-(BOOL)isBlank;
-(BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;

@end
