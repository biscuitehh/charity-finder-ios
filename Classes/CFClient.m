//
//  CFClient.m
//  Charity Finder
//
//  Created by Michael Thomas on 2/27/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import "CFClient.h"
#import <AFHTTPSessionManager.h>
#import <Sync.h>

static NSString * const kBaseURL = @"http://charity.biscuitlabs.com/api/v1";

@interface CFClient ()

@property (nonatomic, strong) DATAStack *dataStack;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation CFClient

#pragma mark - Life Cycle

+ (id)sharedInstance {
    static CFClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)startWithDataStack:(DATAStack *)dataStack {
    [[CFClient sharedInstance] setDataStack:dataStack];
    
    [[CFClient sharedInstance] downloadCharityData:^(NSError *error) {
        NSLog(@"Sync complete!");
    }];
}

#pragma mark - Syncing & network

- (void)downloadCharityData:(void (^)(NSError *error))completion {
    NSLog(@"Starting charity sync!");
    
    // Get last sync, if there is one
    NSString *lastUpdated = [[NSUserDefaults standardUserDefaults] stringForKey:@"last_updated"];
    NSDictionary *params;
    
    if (lastUpdated != nil) {
        params = @{@"last_updated": lastUpdated};
    } else {
        params = @{@"last_updated": @""};
    }
    
    [self.httpManager GET:@"charities" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *charities = (NSArray *)(NSDictionary *)responseObject[@"charities"];
        
        [Sync processChanges:charities usingEntityName:@"Charity" dataStack:self.dataStack completion:^(NSError *error) {
            NSLog(@"Charity sync complete!");
            if(completion) {
                completion(error);
            }
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(completion) {
            completion(error);
        }
    }];
}

#pragma mark - Lazy initialization

- (AFHTTPSessionManager *)httpManager {
    if (_httpManager) {
        return _httpManager;
    }
    
    _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    return _httpManager;
}

@end
