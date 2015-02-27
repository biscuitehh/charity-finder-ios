//
//  ADClusterAnnotation.h
//  AppLibrary
//
//  Created by Patrick Nollet on 01/07/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ADMapCluster.h"
#import "TSClusterAnnotationView.h"

#define kADCoordinate2DOffscreen CLLocationCoordinate2DMake(85.0, 179.0) // this coordinate puts the annotation on the top right corner of the map. We use this instead of kCLLocationCoordinate2DInvalid so that we don't mess with MapKit's KVO weird behaviour that removes from the map the annotations whose coordinate was set to kCLLocationCoordinate2DInvalid.

BOOL ADClusterCoordinate2DIsOffscreen(CLLocationCoordinate2D coord);

typedef enum {
    ADClusterAnnotationTypeUnknown = 0,
    ADClusterAnnotationTypeLeaf = 1,
    ADClusterAnnotationTypeCluster = 2
} ADClusterAnnotationType;

/**
 * Do not subclass or directly modify. This MKAnnotation is a wrapper to keep the annotation static during clustering.
 */
@interface ADClusterAnnotation : NSObject <MKAnnotation>

//MKAnnotation
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


/*!
 * @discussion Type of annotation, cluster or single.
 */
@property (readonly) ADClusterAnnotationType type;

/*!
 * @discussion Cluster tree of annotations.
 */
@property (nonatomic, weak) ADMapCluster *cluster;

/*!
 * @discussion Annotation wrapper to refresh during clustering.
 */
@property (nonatomic, weak) TSClusterAnnotationView *annotationView;

/*!
 * @discussion Set YES for cluster operation to remove after animating.
 */
@property (nonatomic) BOOL shouldBeRemovedAfterAnimation;

/*!
 * @discussion This array contains the MKAnnotation objects represented by this annotation
 */
@property (weak, nonatomic, readonly) NSArray * originalAnnotations;

/*!
 * @discussion Number of annotations represented by the annotation
 */
@property (nonatomic, readonly) NSUInteger clusterCount;

/*!
 * @discussion Needs to have the annotationView refreshed
 */
@property (nonatomic, assign) BOOL needsRefresh;

/**
 * @discussion Should animate scale to pop in onto map
 */
@property (nonatomic, assign) BOOL popInAnimation;

/**
 * @discussion Should animate scale to pop in onto map
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinatePreAnimation;

/**
 * @discussion Remove cluster and make available or reset after animation
 */
- (void)shouldReset;

/**
 * @discussion Remove cluster and move to off-screen position
 */
- (void)reset;

@end
