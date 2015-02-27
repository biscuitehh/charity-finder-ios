//
//  CFMapViewController.m
//  Charity Finder
//
//  Created by Michael Thomas on 2/5/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import "CFMapViewController.h"
#import "CFClient.h"
#import "CFMapView.h"
#import <CoreLocation/CoreLocation.h>
#import <MBXMapKit/MBXMapKit.h>

@interface CFMapViewController () <MKMapViewDelegate, MBXRasterTileOverlayDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet CFMapView *mapView;
@property (nonatomic, strong) MBXRasterTileOverlay *rasterOverlay;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CFMapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup Map
    [self setupMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CFMapView Methods

- (void)setupMap {
    // Setup MapBox
    [MBXMapKit setAccessToken:@"pk.eyJ1IjoiYmlzY3VpdGxhYnMiLCJhIjoic3BVXzVBYyJ9.H3Iu7qmeKOvDgk1NrSz0Eg"];
    
    // Disable some features
    _mapView.showsBuildings = NO;
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;
    
    // Delegate
    _mapView.delegate = self;
    
    // Configure overlay
    _rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:@"biscuitlabs.c7568cda"];
    _rasterOverlay.delegate = self;
    
    [_mapView addOverlay:_rasterOverlay];
    NSLog(@"Raster layer online!");
}

#pragma mark - MKMapViewDelegate protocol implementation

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    // This is boilerplate code to connect tile overlay layers with suitable renderers
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]])
    {
        MBXRasterTileRenderer *renderer = [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // This is boilerplate code to connect annotations with suitable views
    if ([annotation isKindOfClass:[MBXPointAnnotation class]]) {
        static NSString* MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
        }
        view.image = ((MBXPointAnnotation *)annotation).image;
        view.canShowCallout = YES;
        return view;
    }
    return nil;
}

#pragma mark - Location services

- (IBAction)locationServicesAction:(id)sender {
    [self.locationManager requestWhenInUseAuthorization];    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
}

#pragma mark - Lazy initialization

- (CLLocationManager *)locationManager {
    if (_locationManager) {
        return _locationManager;
    }
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100;
    
    return _locationManager;
}

@end
