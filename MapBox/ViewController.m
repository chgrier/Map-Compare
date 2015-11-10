//
//  ViewController.m
//  MapBox
//
//  Created by Charles Grier on 6/2/15.
//  Copyright (c) 2015 Grier Mobile Development. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@import UIKit;
@import CoreGraphics;

@interface ViewController () <MGLMapViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapViewNative;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController
{
    CLLocationCoordinate2D _coordinates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning -- Load Settings bundle to enable opt-out of metrics
#warning -- Enter your Mapbox Access Token in Info.plist
    
    // Set initial coordinates to your favorite location when view loads
    _coordinates = CLLocationCoordinate2DMake( 38.894368, -77.036487);
    
    // Set MapBox view delegate
    self.mapView.delegate = self;
    
    //  set style to Emerald and initizalize Mapbox mapview and
    NSURL *styleURL = [NSURL URLWithString:@"asset://styles/streets-v8.json"];
   //self.mapView = [[MGLMapView alloc] initWithFrame:self.view.constraints styleURL:styleURL];
    [self.mapView setStyleURL:styleURL];
    //self.mapView = [[MGLMapView alloc]initWithFrame:self.view.frame styleURL:styleURL];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    // zoomLevel: 15 ~ MKCoordinateSpanMake(0.004, 0.004)
    // zoomLevel: 16 ~ MKCoordinateSpanMake(0.0025, 0.0025);
    [self.mapView setCenterCoordinate:_coordinates
                       zoomLevel:15 animated:NO];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;

    self.mapViewNative.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Center map coordinates
    CLLocationCoordinate2D center = _coordinates;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);  // one degree of latitude is 69 miles; longitude varies
    MKCoordinateRegion regionToDisplay = MKCoordinateRegionMake(center, span);
    [self.mapViewNative setRegion:regionToDisplay animated:NO];
    
    // Initialize and add gesture recognizer to center maps on new location after long press
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.5;
    [self.mapViewNative addGestureRecognizer:longPressRecognizer];

    UILongPressGestureRecognizer *longPressRecognizerMapBox = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressMapBox:)];
    longPressRecognizer.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPressRecognizerMapBox];
    
}

- (IBAction)setMapOnUserLocation:(id)sender {
    
    // Locations have different zoom levels
    [self.mapViewNative setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow];
}

-(void)handleLongPress:(UIGestureRecognizer *)recognizer {
    // Make sure of long press on Native Maps
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Find point pressed
        CGPoint touchPoint = [recognizer locationInView:self.mapViewNative];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapViewNative convertPoint:touchPoint toCoordinateFromView:self.mapViewNative];
        _coordinates = touchMapCoordinate;
        NSLog(@"Long Press");
        
        // Move map to coordinates and go to existing coordinate span (zoom level)
        CLLocationCoordinate2D center = touchMapCoordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
        MKCoordinateRegion regionToDisplay = MKCoordinateRegionMake(center, span);
        [self.mapViewNative setRegion:regionToDisplay animated:NO];
        
        [self loadMapBoxView:self.mapView withCoordinate:_coordinates];
        }
}

-(void)handleLongPressMapBox:(UIGestureRecognizer *)recognizer {
    // Make sure of long press on Mapbox Maps
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Find point pressed
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        _coordinates = touchMapCoordinate;
        NSLog(@"Long Press");
        
        // Move map to coordinates and go to existing coordinate span (zoom level)
        CLLocationCoordinate2D center = touchMapCoordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.004, 0.004);
        MKCoordinateRegion regionToDisplay = MKCoordinateRegionMake(center, span);
        [self.mapViewNative setRegion:regionToDisplay animated:NO];
        
        [self loadMapBoxView:self.mapView withCoordinate:_coordinates];
    }
}

// set MapBox view to new coordinates and equivalent zoomLevel and Native map
-(void)loadMapBoxView:(MGLMapView *)mapView withCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView setCenterCoordinate:_coordinates
                       zoomLevel:15
                        animated:YES];
}

/* Map Styles -- Emerald, Light, Dark, Mapbox Streets available in GL
 static NSArray *const kStyleNames = @[
 @"Mapbox Streets",
 @"Emerald",
 @"Light",
 @"Dark",
 @"Bright",
 @"Basic",
 @"Outdoors",
 @"Satellite",
 ];
 */

// Switch Mapbox Map Style
- (IBAction)changeMapStyle:(id)sender {
    
    NSURL *styleURL;
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    switch (segControl.selectedSegmentIndex) {
        case 0: // Mapbox Streets
            styleURL = [NSURL URLWithString:@"asset://styles/map box streets-v8.json"];
            break;
            
        case 1: // Emerald
            styleURL = [NSURL URLWithString:@"asset://styles/emerald-v8.json"];
            break;
            
        case 2: // Light
            styleURL = [NSURL URLWithString:@"asset://styles/light-v8.json"];
            break;
            
        case 3: // Dark
            styleURL = [NSURL URLWithString:@"asset://styles/dark-v8.json"];
            break;
    }
    
    // remove existing style
    [self.mapView removeStyleClass:[NSString stringWithContentsOfURL:styleURL encoding:NSUTF8StringEncoding error:nil]];
    
    [self.mapView setStyleURL:styleURL];
}

@end
