//
//  CFMapViewController.m
//  Charity Finder
//
//  Created by Michael Thomas on 2/5/15.
//  Copyright (c) 2015 Biscuit Labs, LLC. All rights reserved.
//

#import "CFMapViewController.h"
#import "CFClient.h"
#import "Charity.h"
#import "CFMapView.h"
#import <CoreLocation/CoreLocation.h>
#import <MBXMapKit/MBXMapKit.h>

@interface CFMapViewController () <MKMapViewDelegate, MBXRasterTileOverlayDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DATAStack *dataStack;
@property (nonatomic, weak) IBOutlet CFMapView *mapView;
@property (nonatomic, strong) MBXRasterTileOverlay *rasterOverlay;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CFMapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup backend
    _dataStack = [[CFClient sharedInstance] dataStack];
    
    // Setup map
    [self setupMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreData

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self fetchedResultsChangeInsert:anObject];
            break;
        case NSFetchedResultsChangeDelete:
            [self fetchedResultsChangeDelete:anObject];
            break;
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsChangeUpdate:anObject];
            break;
        case NSFetchedResultsChangeMove:
            // do nothing
            break;
            
        default:
            break;
    }
}

- (void)fetchedResultsChangeInsert:(Charity *)charity {
    NSLog(@"INSERT!");
//    [self.mapView addAnnotation:charity];
}

- (void)fetchedResultsChangeDelete:(Charity *)familyMember {
    NSLog(@"DELETE!");
//    [self.mapView removeAnnotation:charity];
}

- (void)fetchedResultsChangeUpdate:(Charity *)charity {
    [self fetchedResultsChangeDelete:charity];
    [self fetchedResultsChangeInsert:charity];
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
    
    [self fetchedResultsController];
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

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchedResultsController *frc = nil;
    
    if (self.dataStack) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Charity"];
        
        // TODO - add predicate for current map bounding box.
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSManagedObjectContext *moc = self.dataStack.mainContext;
        
        frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        [frc setDelegate:self];
        
        _fetchedResultsController = frc;
        
        NSError *error = nil;
        [_fetchedResultsController performFetch:&error];
        
        [self loadAnnotations];
    }
    
    return _fetchedResultsController;
}

// TODO - replace this with quad tree clustering
- (void)loadAnnotations {
    // Remove old annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Create annotations for charities
    NSMutableArray *annotations = [NSMutableArray new];
    for (Charity *c in [self.fetchedResultsController fetchedObjects]) {
        
    }
    
    [self.mapView addAnnotations:annotations];
}

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
