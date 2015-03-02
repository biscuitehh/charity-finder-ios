//
//  CFClient.h
//  Charity Finder
//
//  Created by Michael Thomas on 2/27/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DATAStack.h>

@interface CFClient : NSObject

+ (id)sharedInstance;
+ (void)startWithDataStack:(DATAStack *)dataStack;
- (void)downloadCharityDataAtStart:(NSInteger)start count:(NSInteger)count completion:(void (^)(NSError *error))completion;

@end
