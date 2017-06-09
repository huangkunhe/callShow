//
//  CallDirectoryHandler.m
//  CallMark
//
//  Created by river on 2017/2/8.
//  Copyright © 2017年 richinfo. All rights reserved.
//

#import "CallDirectoryHandler.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    @autoreleasepool {
        
        NSInteger startRow = 1;
        NSInteger count = 0;
        NSInteger length = 1000;
        int i =1;
        do {
            count = 0;
            @try{
                NSArray *numbers = [[TeleInterceptionSDK new] getMarkedNumber:startRow to:length*i];
                count = [numbers count];
                if (count > 0) {
                    for (SCPhoneNumber *numInfo in numbers) {
                        
                        CXCallDirectoryPhoneNumber number = [numInfo.phone longLongValue];
                        
                        [context addIdentificationEntryWithNextSequentialPhoneNumber:number label:numInfo.mark];
                    }
                }
                startRow = length*i+1;
                i=i+1;
                if (count < length) {
                    count=0;
                }
                
            }
            @catch (NSException *e)
            {
                NSLog(@"%@", e.reason);
            }@finally {
                
            }
        } while (count > 0);
        
    }

    return YES;
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
