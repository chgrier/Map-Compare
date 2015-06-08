//
//  MyAnnotation.h
//  MapBox
//
//  Created by Charles Grier on 6/3/15.
//  Copyright (c) 2015 Grier Mobile Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxGL/MGLAnnotation.h>

@interface MyAnnotation : NSObject <MGLAnnotation>

+ (instancetype)annotationWithLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;

@end
