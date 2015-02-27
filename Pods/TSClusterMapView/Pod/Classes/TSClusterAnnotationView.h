//
//  TSClusterAnnotationView.h
//  ClusterDemo
//
//  Created by Adam Share on 1/14/15.
//  Copyright (c) 2015 Applidium. All rights reserved.
//

#import <MapKit/MapKit.h>


/**
 * Do not subclass. This MKAnnotationView is a wrapper to keep the annotation view static during clustering.
 */
@interface TSClusterAnnotationView : MKAnnotationView

- (MKAnnotationView *)updateWithAnnotationView:(MKAnnotationView *)annotationView;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier containingAnnotationView:(MKAnnotationView *)contentView;

- (void)animateView;


@end
