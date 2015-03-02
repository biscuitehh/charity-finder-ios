//
//  Charity.h
//  Charity Finder
//
//  Created by Michael Thomas on 2/27/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Charity : NSManagedObject

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSString * ein;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
